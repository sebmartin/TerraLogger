//
//  Coordinate+KML.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import RCKML

extension Coordinate {
    convenience init(from coordinate: KMLCoordinate) {
        self.init(coordinate.latitude, coordinate.longitude, altitude: coordinate.altitude)
    }
}
