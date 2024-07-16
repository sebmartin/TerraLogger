//
//  Coordinate.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-02.
//
import SwiftUI
import SwiftData
import CoreLocation

@Model
final class Coordinate {
    var order: Int
    var latitude: Double
    var longitude: Double
    var altitude: Double?
    var recordedAt: Date?
    var createdAt: Date
    
//    @Relationship(deleteRule: .noAction) var trail: Trail?
    
    init(_ latitude: Double, _ longitude: Double, altitude: Double? = nil, recordedAt: Date? = nil, order: Int = 0, trail: Trail? = nil) {
        self.order = order
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.recordedAt = recordedAt
        self.createdAt = Date.now
//        self.trail = trail
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "\(type(of: self))(\(latitude), \(longitude), altitude: \(altitude != nil ? "\(altitude!)" : "nil"))"
    }
}

extension Coordinate: Equatable {
    static func ==(coord1: Coordinate, coord2: Coordinate) -> Bool {
        return (
            coord1.latitude == coord2.latitude &&
            coord1.longitude == coord2.longitude &&
            coord1.altitude == coord2.altitude
        )
    }
}

extension Coordinate: Comparable {
    static func < (lhs: Coordinate, rhs: Coordinate) -> Bool {
        lhs.order < rhs.order
    }
}

// - MARK: Helpers

extension CLLocationCoordinate2D {
    init(coordinate: Coordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
