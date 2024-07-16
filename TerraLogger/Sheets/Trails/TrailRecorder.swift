//
//  TrailRecorder.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-31.
//
import os
import Combine
import SwiftUI
import MapboxMaps
import SwiftData

fileprivate let logger = Logger.importer

struct TrailRecorder {
    let locationProvider: LocationUpdatable
    @Binding var trail: Trail

    var stopTracking: AnyCancellable? = nil

    mutating func startRecording() {
        if stopTracking != nil {
            logger.warning("Tried to start recording trail when recorder is already active; request was ignored.")
        }
        stopTracking = locationProvider.onLocationUpdate.sink(receiveValue: self.onLocationUpdate(locations:))
    }
    
    mutating func stopRecording() {
        stopTracking?.cancel()
        stopTracking = nil
    }
    
    private func onLocationUpdate(locations: [Location]) {
        for location in locations {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            let alt = location.altitude ?? 0.0 as Double
            let coord = Coordinate(lat, lng, altitude: alt, recordedAt: Date.now)
            self.trail.coordinates.append(coord)
            logger.debug("Recorded new location: \(coord)")
        }
    }
}

protocol LocationUpdatable {
    var onLocationUpdate: Signal<[Location]> { get }
}

extension AppleLocationProvider: LocationUpdatable {}
