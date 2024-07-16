//
//  TrailRecorderTests.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-31.
//

import Testing
import SwiftUI
import MapboxMaps
@testable import TerraLogger
import Combine

struct TrailRecorderTests {
    @Test func receivingLocationsUpdatesTrailCoordinates() async throws {
        var trail = Trail(name: "foo", coordinates: [])
        let trailBinding = Binding {
            trail
        } set: {
            trail = $0
        }

        let locationProvider = FakeLocationProvider()
        locationProvider.locations.publisher.sink { _ in
            NSLog("boop")
        }
        
        var trailRecorder = TrailRecorder(locationProvider: locationProvider, trail: trailBinding)
        trailRecorder.startRecording()
        
        locationProvider.locations = [
            Location(coordinate: CLLocationCoordinate2D(latitude: 45, longitude: -75))
        ]
        
        #expect(trail.coordinates.count > 0)
    }
}



class FakeLocationProvider: LocationUpdatable {    
    @Published var locations: [Location] = []
    private lazy var signal: Signal<Location> = {
        locations.publisher.eraseToSignal()
    }()
    
    var onLocationUpdate: Signal<Location> {
        get {
            return self.signal
        }
    }
}


