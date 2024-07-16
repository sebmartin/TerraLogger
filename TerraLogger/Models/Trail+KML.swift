//
//  Trail+KML.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import RCKML

extension Trail {
    convenience init?(fromPlacemark placemark: KMLPlacemark) {
        guard let geometry = placemark.geometry as? KMLLineString else {
            return nil
        }
        self.init(name: placemark.name, coordinates: geometry.coordinates.enumerated().map { order, coord in
            Coordinate(from: coord, order: order)
        })
    }
}