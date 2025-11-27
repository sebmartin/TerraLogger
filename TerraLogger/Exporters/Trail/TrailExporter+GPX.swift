//
//  TrailExporter+GPX.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-24.
//
import Foundation
import GPXKit

extension TrailExporter {
    func toGPX(trail: Trail) throws -> Data {
        let track = GPXTrack(title: trail.name, trackPoints: trail.coordinates
            .sorted(by: { $0.createdAt < $1.createdAt })
            .map {
                TrackPoint(coordinate: GPXKit.Coordinate(latitude: $0.latitude, longitude: $0.longitude))
            })
        let exporter = GPXExporter(track: track, shouldExportDate: false)
        return Data(exporter.xmlString.utf8)
    }
}
