//
//  Coordinate+CoreLocation.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-09-20.
//
import CoreLocation

extension Coordinate {
    convenience init(from location: CLLocation) {
        self.init(
            location.coordinate.latitude,
            location.coordinate.longitude,
            altitude: location.altitude,
            speed: location.speed,
            speedAccuracy: location.speedAccuracy,
            horizontalAccuracy: location.horizontalAccuracy,
            verticalAccuracy: location.verticalAccuracy,
            recordedAt: location.timestamp
        )
    }
    
    convenience init(from coordinate: CLLocationCoordinate2D) {
        self.init(
            coordinate.latitude,
            coordinate.longitude,
        )
    }
}
