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
        let coordinates = geometry.coordinates.map { coord in
            Coordinate(from: coord)
        }
        self.init(name: placemark.name, coordinates: coordinates, status: .importing, source: .imported)
    }
}
