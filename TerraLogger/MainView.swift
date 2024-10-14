//
//  ContentView.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-15.
//

import os
import SwiftUI
import SwiftData
import Combine
import ActivityKit
@_spi(Experimental) import MapboxMaps

fileprivate let logger = Logger.main

enum MapSheet: String, Identifiable {
    case trails
    case pins
    case favourites
    case menu
    
    var id: String { rawValue }
}

struct MainView: View {
    @Environment(\.modelContext) var context
    let nc = NotificationCenter.default

    let locationProvider = AppleLocationProvider()
    var trailRecorder = TrailRecorder()

    // Initial positioning of the viewport
    @State var viewport = Viewport.overview(
        geometry: MultiPoint(
            [
                // Infinite Loop
                LocationCoordinate2D(latitude: 37.333967, longitude: -122.031858),
                LocationCoordinate2D(latitude: 37.33070456, longitude: -122.01970909),
            ]
        ),
        geometryPadding: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    )
    @State var cameraState: CameraState? = nil
    
    // Trail data
    @Query var allTrails: [Trail]
    var completedTrails: [Trail] { allTrails.filter { $0.persistentModelID != self.recordingTrail?.persistentModelID } }
    private var recordingTrailQuery: Trail? {
        guard trailRecorder.isRecording else { return nil }
        return allTrails
            .sorted { $0.createdAt < $1.createdAt }
            .first { $0.status == .recording }
    }
    @State var recordingTrail: Trail? = nil
    
    // Boundary data
    @State var boundaries: [Boundary] = [
        Boundary.infiniteLoop(),
        Boundary.centralPark()
    ]
        
    init() {
        // Prefetch coordinates for each trail
        var descriptor = FetchDescriptor<Trail>()
        descriptor.relationshipKeyPathsForPrefetching = [\Trail.coordinates]
        _allTrails = Query(descriptor)
    }

    @State var presentedSheet: MapSheet?
    @State var presentFileIMporter: Bool = true

    var body: some View {
        ZStack  {
            MapView(
                viewport: $viewport,
                cameraState: $cameraState,
                locationProvider: locationProvider,
                completedTrails: completedTrails,
                recordingTrail: $recordingTrail,
                boundaries: $boundaries
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                VStack(alignment: .trailing) {
                    MapButton("location.circle") { centerOnUserLocation() }
                    MapButton("map") {
                        // TODO: Move this to the trails sheet (temp)
                        let trailRecorder = self.trailRecorder
                        Task {
                            if trailRecorder.isRecording {
                                await trailRecorder.stopRecording()
                            } else {
                                let trailId = await trailRecorder.startRecording(
                                    trailName: "New Trail",
                                    modelContainer: self.context.container
                                )
                                let x = String(describing: trailId)
                                logger.info("trail: \(x)")
                            }
                        }
                    }
                    MapButton("tag")
                }
                .containerRelativeFrame([.horizontal], alignment: .trailing)
                .padding(.trailing, 20)
                Spacer()
                MapActionButtons(presentedSheet: $presentedSheet)
            }
            .containerRelativeFrame([.horizontal, .vertical], alignment: .bottom)
        }
        .sheet(item: $presentedSheet, onDismiss: {}) { sheet in
            NavigationView {
                switch sheet {
                case .trails:
                    TrailsSheet(trails: self.allTrails)
                case .pins:
                    Text("pins")
                case .favourites:
                    Text("favourites")
                case .menu:
                    Text("menu")
                }
            }
        }
        
        // This is a bit of a hack to get around an issue with the MapboxMap where annotations
        // are not updated even if the model changes. Adding and removing is the recommended
        // way to force the map to update its annotations.
        // - recordingTrailQuery updates when the @Query responds to changes
        // - recordingTrail is the @State var bound to the map
        .onChange(of: recordingTrailQuery) { old, new in
            recordingTrail = recordingTrailQuery
        }
        .onChange(of: recordingTrailQuery?.coordinates) { old, new in
            recordingTrail = nil  // removes the annotation
            recordingTrail = recordingTrailQuery  // adds it back forcing an update
        }
        
        .onReceive(nc.publisher(for: Notification.Name.requestedStartRecordingTrail)) { _ in
            
        }
    }
    
    func centerOnUserLocation() {
        switch (viewport) {
        case .idle:
            viewport = .followPuck(zoom: cameraState?.zoom ?? 18)
        default:
            viewport = .idle
        }
    }
    
    // MARK: - Trails
    
    private func startRecordingTrail(trail: Trail) {
        
    }
    
    @MainActor
    private func updateTrailActivity(distance: Double) {
        Task {
            for activity in Activity<TrailAttributes>.activities {
                let updatedState = TrailAttributes.ContentState(
                    distance: 0.0, duration: .seconds(0), totalElevation: 0.0, accuracy: 0, speed: 0
                )
                logger.info("Updating activity with distance: \(distance)")
                await activity.update(.init(state: updatedState, staleDate: nil), timestamp: Date.now)
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: allModels, inMemory: true)
}
