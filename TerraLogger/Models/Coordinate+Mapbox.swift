//
//  Coordinate+Mapbox.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-09-01.
//
import MapboxMaps

extension Coordinate {
    convenience init(location: Location, recordedAt: Date, order: Int) {
        self.init(
            location.coordinate.latitude,
            location.coordinate.longitude,
            altitude: location.altitude,
            recordedAt: recordedAt,
            order: order
        )
    }
}
