//
//  Coordinate+Mapbox.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-09-01.
//
import MapboxMaps

extension Coordinate {
    convenience init(location: Location, recordedAt: Date) {
        self.init(
            location.coordinate.latitude,
            location.coordinate.longitude,
            altitude: location.altitude,
            speed: location.speed,
            speedAccuracy: location.speedAccuracy,
            horizontalAccuracy: location.horizontalAccuracy,
            verticalAccuracy: location.verticalAccuracy,
            recordedAt: recordedAt
        )
    }
}
