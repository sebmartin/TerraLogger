//
//  ContentView.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-15.
//

import SwiftUI
import SwiftData
import Combine
@_spi(Experimental) import MapboxMaps

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
        
        var coordinateOrder = 0
        let trail = Trail(name: "Name", coordinates: [], status: .recording, source: .recorded)
        context.insert(trail)
        try? context.save()
        
        stopTracking = locationProvider.onLocationUpdate.sink(receiveCompletion: { _ in
            trail.status = .complete
            try? context.save()
        }) { locations in
            for location in locations {
                trail.coordinates.append(
                    Coordinate(
                        location: location,
                        recordedAt: Date.now
                    )
                )
                coordinateOrder += 1
            }
            try? context.save()
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
