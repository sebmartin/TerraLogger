//
//  Boundary.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-02.
//
import SwiftUI
import SwiftData
import MapboxMaps

@Model
final class Boundary {
    var name: String
    var coordinates: [Coordinate]
    
    init(name: String, coordinates: [Coordinate], uiColor: UIColor? = nil) {
        self.name = name
        self.coordinates = coordinates
    }
}

extension Boundary {
    func polygonAnnotation() -> PolygonAnnotation {
        return PolygonAnnotation(polygon: Polygon([self.coordinates.map {
            CLLocationCoordinate2D(
                latitude: $0.latitude,
                longitude: $0.longitude
            )
        }]))
    }
    
    func polylineAnnotation() -> PolylineAnnotation {
        return PolylineAnnotation(lineCoordinates:
            self.coordinates.map {
                CLLocationCoordinate2D(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
        )
    }
}

extension Boundary {
    static func infiniteLoop() -> Self {
        return Self(name: "Infinite Loop", coordinates: [
            Coordinate(37.3306138, -122.0305459),
            Coordinate(37.3306181, -122.0304118),
            Coordinate(37.3306181, -122.0290707),
            Coordinate(37.3306351, -122.0289473),
            Coordinate(37.3306948, -122.0288186),
            Coordinate(37.3308057, -122.0287059),
            Coordinate(37.3309721, -122.0286094),
            Coordinate(37.3326356, -122.0286094),
            Coordinate(37.3328617, -122.0286469),
            Coordinate(37.3331048, -122.0287757),
            Coordinate(37.3332712, -122.0289849),
            Coordinate(37.3333906, -122.0292102),
            Coordinate(37.3334546, -122.0294784),
            Coordinate(37.3334716, -122.0296876),
            Coordinate(37.3334674, -122.0298271),
            Coordinate(37.3334119, -122.0300631),
            Coordinate(37.333301, -122.0302884),
            Coordinate(37.3331645, -122.0304601),
            Coordinate(37.3330238, -122.0305835),
            Coordinate(37.3328873, -122.0306586),
            Coordinate(37.332674, -122.0307122),
            Coordinate(37.3311214, -122.0307229),
            Coordinate(37.3306138, -122.0305459),
        ])
    }
    
    static func centralPark() -> Self {
        return Self(name: "Central Park", coordinates: [
            
        ])
    }
}
