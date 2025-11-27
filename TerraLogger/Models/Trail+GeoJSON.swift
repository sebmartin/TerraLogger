//
//  Trail+GeoJSON.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-23.
//

import Turf

extension Trail {   
    convenience init?(fromGeoJSON geojson: GeoJSONObject, name: String? = nil) {
        guard case let .feature(feature) = geojson,
              case let .lineString(lineString) = feature.geometry else {
            return nil
        }
        let coordinates = lineString.coordinates.map {
            Coordinate(from: $0)
        }
        self.init(name: name ?? "Imported GeoJSON", coordinates: coordinates, status: .complete, source: .imported)
    }
}
