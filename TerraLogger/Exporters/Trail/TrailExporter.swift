//
//  TrailExporter.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-23.
//
import Foundation

enum TrailExportError: Error {
    case unknownError
    case trailNotFound
    case notImplemented
}

extension TrailExportError: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknownError: "Unknown error"
        case .trailNotFound: "Trail not found"
        case .notImplemented: "Not implemented"
        }
    }
}

struct TrailExporter {
    func export(trail: Trail, format: TrailExportFormat) throws -> Data {
        do {
            switch format {
            case .geoJSON:
                return try toGeoJson(trail: trail)
            case .kml:
                return try toKML(trail: trail, compress: false)
            case .kmz:
                return try toKML(trail: trail, compress: true)
            case .gpx:
                return try toGPX(trail: trail)
            }
        }
    }
}
