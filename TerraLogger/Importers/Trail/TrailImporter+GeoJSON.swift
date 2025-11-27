//
//  TrailImporter+GeoJSON.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-23.
//
import Foundation
import Turf

extension TrailImporter {
    internal static func fromGeoJSON(url: URL) throws -> [Trail] {
        let data = try Data(contentsOf: url)
        let geojson = try JSONDecoder().decode(GeoJSONObject.self, from: data)
        
        // TODO: support multiple?
        if let trail = Trail(fromGeoJSON: geojson) {
            return [trail]
        }
        throw ImportError.parseError
    }
}
