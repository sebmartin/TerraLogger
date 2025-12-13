//
//  Trail+GeoJSON.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-23.
//
import os
import Turf

fileprivate let logger = Logger.importer

extension Trail {   
    convenience init?(fromGeoJSON geojson: GeoJSONObject, name: String? = nil) {
        switch geojson {
        case .feature(let feature):
            if case let .lineString(lineString) = feature.geometry {
                self.init(lineString, name: name)
                return
            }
            return nil
            
        case .featureCollection(let collection):
            for feature in collection.features {
                if case let .lineString(lineString) = feature.geometry {
                    self.init(lineString, name: name)
                    return
                }
            }
            logger.error("Could not pares GeoJSON: \(String(describing: collection))")
            return nil

        default:
            logger.error("Could not pares GeoJSON: \(String(describing: geojson))")
            return nil
        }
    }
    
    private convenience init?(_ lineString: LineString, name: String? = nil) {
        let coordinates = lineString.coordinates.map {
            Coordinate(from: $0)
        }
        self.init(name: name ?? "Imported GeoJSON", coordinates: coordinates, status: .complete, source: .imported)
    }
}
