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
    @State var stopTracking: AnyCancellable? = nil

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
    var completedTrails: [Trail] { allTrails.filter { $0.status == .complete } }
    var recordingTrail: Trail? { allTrails.first { $0.status == .recording } }
    
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
                trails: completedTrails,
                recordingTrail: recordingTrail,
                boundaries: $boundaries
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                VStack(alignment: .trailing) {
                    MapButton("location.circle") { centerOnLocation() }
                    MapButton("map") {
                        startRecordingTrail()
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
    
    func startRecordingTrail() {
        if stopTracking != nil {
            stopRecordingTrail()
            return
        }
        
        let trail = Trail(name: "Name", coordinates: [], status: .recording, source: .recorded)
        context.insert(trail)
        try? context.save()
        
        let startTime = Date.now
        do {
            let attributes = TrailAttributes(name: trail.name)
            let initialState = TrailAttributes.ContentState(
                distance: 0.0, duration: .seconds(0), totalElevation: 0.0, accuracy: 0, speed: 0
            )
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            logger.info("Started live activity with id: \(activity.id)")
        } catch {
            print("Error starting live activity: \(error.localizedDescription)")
        }
        
        var lastCoordinate: Coordinate? = nil
        stopTracking = locationProvider.onLocationUpdate.sink(receiveCompletion: { _ in
            trail.status = .complete
            try? context.save()
        }) { locations in
            for location in locations {
                // Record the new coordinate
                let coordinate = Coordinate(
                    location: location,
                    recordedAt: Date.now
                )
                trail.coordinates.append(coordinate)
                
                // Update the live activity
                updateTrailActivity(distance: coordinate.distance(to: lastCoordinate))
//                let distance = coordinate.distance(to: lastCoordinate)
                lastCoordinate = coordinate
            }
            try? context.save()
        }
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
    
    func stopRecordingTrail() {
        stopTracking?.cancel()
        if let recordingTrail = recordingTrail {
            recordingTrail.status = .complete
            try? context.save()
        }
        stopTracking = nil
    }
}

#Preview {
    MainView()
        .modelContainer(for: allModels, inMemory: true)
}
