//
//  Trail+Transferable.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-22.
//
import os
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

fileprivate let logger = Logger.exporter


extension UTType {
  static let gpx = UTType(exportedAs: "com.topografix.gpx", conformingTo: .xml)
}

protocol TrailTransferable: Transferable, Sendable {
    var id: PersistentIdentifier { get }
    var suggestedFilename: String? { get set }
    var modelContainer: ModelContainer { get }
    
    init(id: PersistentIdentifier, suggestedFilename: String?, modelContainer: ModelContainer)
}

extension TrailTransferable {
    func export(format: TrailExportFormat) async throws -> Data {
        do {
            return try await Exporter(modelContainer: modelContainer).export(trailId: id, format: format)
        } catch let error {
            logger.error("Error occured while exporting to format \(format): \(error)")
            throw error
        }
    }
}

struct TrailGeoJSONTransferable: TrailTransferable {
    let id: PersistentIdentifier
    var suggestedFilename: String? = nil
    let modelContainer: ModelContainer
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .geoJSON) { item in
            return try await item.export(format: .geoJSON)
        }
        .suggestedFileName { "\($0.suggestedFilename ?? "Trail").geojson" }
    }
}

struct TrailKMLTransferable: TrailTransferable {
    let id: PersistentIdentifier
    var suggestedFilename: String? = nil
    let compress: Bool? = true
    let modelContainer: ModelContainer
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .kml) { item in
            return try await item.export(format: .kml)
        }
        .suggestedFileName { "\($0.suggestedFilename ?? "Trail").kml" }
    }
}

struct TrailKMZTransferable: TrailTransferable {
    let id: PersistentIdentifier
    var suggestedFilename: String? = nil
    let compress: Bool? = true
    let modelContainer: ModelContainer
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .kmz) { item in
            return try await item.export(format: .kmz)
        }
        .suggestedFileName { "\($0.suggestedFilename ?? "Trail").kml" }
    }
}

struct TrailTransferableGPX: TrailTransferable {
    let id: PersistentIdentifier
    var suggestedFilename: String? = nil
    let modelContainer: ModelContainer
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .gpx) { item in
            return try await item.export(format: .gpx)
        }
        .suggestedFileName { "\($0.suggestedFilename ?? "Trail").gpx" }
    }
}

extension Trail {
    func geoJsonTransferable(modelContainer: ModelContainer) -> TrailGeoJSONTransferable {
        return .init(id: id, suggestedFilename: name, modelContainer: modelContainer)
    }
    
    func kmlTransferable(modelContainer: ModelContainer) -> TrailKMLTransferable {
        return .init(id: id, suggestedFilename: name, modelContainer: modelContainer)
    }
    
    func kmzTransferable(modelContainer: ModelContainer) -> TrailKMLTransferable {
        return .init(id: id, suggestedFilename: name, modelContainer: modelContainer)
    }
    
    func gpxTransferable(modelContainer: ModelContainer) -> TrailTransferableGPX {
        return .init(id: id, suggestedFilename: name, modelContainer: modelContainer)
    }
}
