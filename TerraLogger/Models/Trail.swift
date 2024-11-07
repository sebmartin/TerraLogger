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

public struct TrailStats {
    let duration: Duration
    let distance: Double // meters
    let elevationGain: Double //
    
    private(set) var lastCoordinate: Coordinate? = nil
    
    init(duration: Duration, distance: Double, elevationGain: Double) {
        self.duration = duration
        self.distance = distance
        self.elevationGain = elevationGain
    }
    
    private init(duration: Duration, distance: Double, elevationGain: Double, lastCoordinate: Coordinate?) {
        self.duration = duration
        self.distance = distance
        self.elevationGain = elevationGain
        self.lastCoordinate = lastCoordinate
    }
    
    static var initial: Self {
        return TrailStats(duration: Duration.zero, distance: 0.0, elevationGain: 0.0)
    }
    
    func updated(with coordinates: [Coordinate]) -> Self {
        var coordinates = coordinates
        var duration = self.duration
        var distance = self.distance
        var elevationGain = self.elevationGain
        
        var lastCoordinate: Coordinate? = self.lastCoordinate
        if lastCoordinate == nil && coordinates.count > 0 {
            lastCoordinate = coordinates.removeFirst()
        }
        
        guard !coordinates.isEmpty, var lastCoordinate = lastCoordinate else {
            // No coordinates to process
            return TrailStats(duration: duration, distance: distance, elevationGain: elevationGain, lastCoordinate: lastCoordinate)
        }
        
        // Calculate duration
        if let prevRecordedAt = lastCoordinate.recordedAt, let lastRecordedAt = coordinates.last?.recordedAt {
            let interval = lastRecordedAt.timeIntervalSince(prevRecordedAt)
            duration += .seconds(interval)
        }
        
        // And the rest...
        for coord in coordinates {
            distance += lastCoordinate.distance(to: coord)
            let diffAltitude = (coord.altitude ?? 0) - (lastCoordinate.altitude ?? 0)
            elevationGain = max(elevationGain, elevationGain + diffAltitude)
            lastCoordinate = coord
        }

        return TrailStats(duration: duration, distance: distance, elevationGain: elevationGain, lastCoordinate: lastCoordinate)
    }
}

extension Trail {
    
    var stats: TrailStats {
        return self.updated(stats: TrailStats.initial)
    }
    
    func updated(stats: TrailStats) -> TrailStats {
        let index = { (lastCoordinate: Coordinate?) in
            if let lastCoordinate = stats.lastCoordinate {
                return self.coordinates.firstIndex(of: lastCoordinate) ?? 0
            }
            return 0
        }(stats.lastCoordinate)
        
        let unseenCoords = self.coordinates[index...]
        return stats.updated(with: Array(unseenCoords))
    }
}
