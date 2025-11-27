//
//  TrailExporter+KML.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-24.
//
import Foundation
import RCKML

extension TrailExporter {
    func toKML(trail: Trail, compress: Bool = true) throws -> Data {
        let document = KMLDocument(
            name: trail.name,
            features: [
                KMLPlacemark(
                    name: trail.name,
                    geometry: KMLLineString(
                        coordinates: trail.coordinates
                            .sorted(by: { $0.createdAt < $1.createdAt })
                            .map {
                                KMLCoordinate(latitude: $0.latitude, longitude: $0.longitude, altitude: $0.altitude)
                            }
                    )
                )
            ]
        )
        if compress {
            return try document.kmzData()
        } else {
            return try document.kmlData()
        }
    }
}
