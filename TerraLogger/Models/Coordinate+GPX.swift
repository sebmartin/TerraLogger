//
//  Coordinate+GPX.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-12.
//
import GPXKit

extension Coordinate {
    convenience init?(from trackpoint: TrackPoint) {
        self.init(
            trackpoint.latitude,
            trackpoint.longitude,
            altitude: trackpoint.elevation,
            speed: trackpoint.speed?.converted(to: .metersPerSecond).value
        )
    }
}
