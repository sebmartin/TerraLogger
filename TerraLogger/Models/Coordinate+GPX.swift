//
//  Coordinate+GPX.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-12.
//
import GPXKit

extension Coordinate {
    convenience init?(from trackpoint: TrackPoint, order: Int) {
        self.init(trackpoint.latitude, trackpoint.longitude, altitude: trackpoint.elevation, order: order)
    }
}
