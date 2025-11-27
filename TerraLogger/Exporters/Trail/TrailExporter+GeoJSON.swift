//
//  TrailExporter+GeoJSON.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-23.
//
import Turf

extension TrailExporter {
    func toGeoJson(trail: Trail) throws -> Data {
        let multiPoint = LineString(
            trail.coordinates
                .sorted(by: { $0.createdAt < $1.createdAt })
                .asLocationCoordinate2Ds()
        )
        return try JSONEncoder().encode(Feature(geometry: multiPoint))
    }
}
