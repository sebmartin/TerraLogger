//
//  Trail.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-06.
//
import SwiftData
import Foundation

enum TrailStatus: String, Codable {
    case importing = "importing"
    case recording = "recording"
    case complete = "complete"
}

enum TrailSource: String, Codable {
    case unknown = "unknown"
    case imported = "imported"
    case recorded = "recorded"
}

@Model
final class Trail {
    var name: String
    var statusRaw: String
    var status: TrailStatus {
        get { TrailStatus(rawValue: statusRaw)! }
        set { statusRaw = newValue.rawValue }
    }
    var source: TrailSource
    var createdAt: Date
    var startedAt: Date?
    var endedAt: Date?
    var notes: String
    
    @Relationship(deleteRule: .cascade) var coordinates: [Coordinate]
    
    init(name: String, coordinates: [Coordinate], status: TrailStatus, source: TrailSource, startedAt: Date? = nil, endedAt: Date? = nil) {
        self.name = name
        self.statusRaw = status.rawValue
        self.source = source
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.createdAt = Date.now
        self.notes = ""
        self.coordinates = coordinates
    }
}
