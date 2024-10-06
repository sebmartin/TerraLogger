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
    
    @Query var allTrails: [Trail]
    var completedTrails: [Trail] { allTrails.filter { $0.persistentModelID != self.recordingTrail?.persistentModelID } }
    var recordingTrail: Trail? {
        allTrails
            .sorted { $0.createdAt < $1.createdAt }
            .first { $0.status == .recording }
    }
    
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
                locationProvider: locationProvider,
                completedTrails: completedTrails,
                recordingTrail: recordingTrail,
                boundaries: $boundaries
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                VStack(alignment: .trailing) {
                    MapButton("location.circle") { centerOnLocation() }
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
    }
    
    func centerOnLocation() {
        if let location = locationProvider.latestLocation {
            viewport = .camera(center: location.coordinate)
        }
    }
    
    // MARK: - Trails
    
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
