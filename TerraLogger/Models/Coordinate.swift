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
    var latitude: Double
    var longitude: Double
    var altitude: Double? = nil
    var speed: Double? = nil
    var speedAccuracy: Double? = nil
    var horizontalAccuracy: Double? = nil
    var verticalAccuracy: Double? = nil
    
    var recordedAt: Date?
    var createdAt: Date
    
    init(_ latitude: Double, _ longitude: Double, altitude: Double? = nil, speed: Double? = nil, speedAccuracy: Double? = nil, horizontalAccuracy: Double? = nil, verticalAccuracy: Double? = nil, recordedAt: Date? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speed = speed
        self.speedAccuracy = speedAccuracy
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.recordedAt = recordedAt
        self.createdAt = Date.now
    }
}

// - MARK: geo methods

extension Coordinate {
    func distance(to: Coordinate?) -> Double {
        guard let to = to else {
            return 0
        }
        
        // Haversine formula -- https://www.movable-type.co.uk/scripts/latlong.html
        let R = 6371e3 // metres
        let φ1 = latitude.degreesToRadians
        let φ2 = to.latitude.degreesToRadians
        let Δφ = (to.latitude - latitude).degreesToRadians
        let Δλ = (to.longitude - longitude).degreesToRadians

        let a = sin(Δφ / 2) * sin(Δφ / 2) +
            cos(φ1) * cos(φ2) *
            sin(Δλ / 2) * sin(Δλ / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let d = R * c
        return d // meters
    }
}

// - MARK: Standard protocols

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
        lhs.createdAt < rhs.createdAt
    }
}

// - MARK: Helpers

fileprivate extension Double {
    var degreesToRadians: Double {
        return self * Self.pi / 180
    }
}

extension CLLocationCoordinate2D {
    init(coordinate: Coordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
