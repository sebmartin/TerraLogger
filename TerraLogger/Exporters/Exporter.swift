//
//  Exporter.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-23.
//
import Foundation
import SwiftUI
import SwiftData

enum TrailExportFormat: CustomStringConvertible {
    case geoJSON
    case kml
    case kmz
    case gpx
    
    var description: String {
        switch self {
        case .geoJSON: return "GeoJSON"
        case .kml: return "KML"
        case .kmz: return "KMZ"
        case .gpx: return "GPX"
        }
    }
}

enum ExportError: Error, CustomStringConvertible {
    case unknownError(message: String)
    case modelNotFound(name: any PersistentModel.Type)
    
    var description: String {
        switch self {
        case .unknownError(message: let message): return "Unknown error: \(message)"
        case .modelNotFound(name: let modelType): return "Model of type \(modelType) not found"
        }
    }
}

@ModelActor actor Exporter {
    public func export(trailId: PersistentIdentifier, format: TrailExportFormat) throws -> Data {
        guard let trail = modelContext.model(for: trailId) as? Trail else {
            // If the model cannot be found, export an empty payload or throw.
            throw ExportError.modelNotFound(name: Trail.self)
        }
        
        return try TrailExporter().export(trail: trail, format: format)
    }
}
