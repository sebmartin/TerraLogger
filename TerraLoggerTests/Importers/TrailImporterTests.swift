//
//  TrailImporterTests.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-12.
//
import Testing
import Foundation
@testable import TerraLogger

private class TestClass {}

struct TrailImporterTests {
    @Test("Can import trails from URL", arguments: [
        "kml", "kmz", "gpx", "geojson"
    ])
    func trailsFromAllTypes(fileExtension: String) async throws {
        let url = Bundle.test.url(forResource: "trails.trail-of-hope", withExtension: fileExtension)!
        let trails = try TrailImporter.from(url: url)
        #expect(trails.count == 1)
        
        let trail = trails[0]
        let expected = Trails.trailOfHope
        #expect(trail.name == expected.name)
        #expect(trail.coordinates == expected.coordinates)
    }
    
    @Test("Unknown url returns an ImportError.invalidUrl")
    func unknownFile() async throws {
        let url = URL(filePath: "not-a-real-url.kml")
        #expect(throws: ImportError.invalidUrl) {
            try TrailImporter.from(url: url)
        }
    }
    
    @Test("Can import KML/KMZ with multiple trails and folders", arguments: [
        "kml", "kmz"
    ])
    func complexTrailsFromKMLTypes(fileExtension: String) async throws {
        let url = Bundle.test.url(forResource: "locations.central-park", withExtension: fileExtension)!
        let trails = try TrailImporter.from(url: url)
        #expect(trails.count == 3, "Should have found 3 trails in separate nested folders")
    }
}


internal struct Trails {
    // TODO: update, this is from Central Park Vancouver!
    static let trailOfHope = Trail(
        name: "Central Park - Trail of Hope",
        coordinates: [Coordinate(49.22924, -123.02349, altitude: 0.0), Coordinate(49.22908, -123.02323, altitude: 0.0), Coordinate(49.22887, -123.023, altitude: 0.0), Coordinate(49.22875, -123.02284, altitude: 0.0), Coordinate(49.22873, -123.02259, altitude: 0.0), Coordinate(49.22873, -123.022, altitude: 0.0), Coordinate(49.22871, -123.02179, altitude: 0.0), Coordinate(49.22861, -123.0215, altitude: 0.0), Coordinate(49.22847, -123.02118, altitude: 0.0), Coordinate(49.22842, -123.02113, altitude: 0.0), Coordinate(49.22825, -123.02072, altitude: 0.0), Coordinate(49.22808, -123.02027, altitude: 0.0), Coordinate(49.22788, -123.01962, altitude: 0.0), Coordinate(49.22766, -123.01925, altitude: 0.0), Coordinate(49.22749, -123.019, altitude: 0.0), Coordinate(49.22722, -123.01844, altitude: 0.0), Coordinate(49.22699, -123.01798, altitude: 0.0), Coordinate(49.2267437, -123.0174861, altitude: 0.0), Coordinate(49.2265, -123.01676, altitude: 0.0), Coordinate(49.226, -123.01535, altitude: 0.0), Coordinate(49.2259237, -123.015135, altitude: 0.0), Coordinate(49.2259, -123.01492, altitude: 0.0), Coordinate(49.22579, -123.01431, altitude: 0.0), Coordinate(49.22575, -123.01402, altitude: 0.0), Coordinate(49.22568, -123.01366, altitude: 0.0), Coordinate(49.22565, -123.01304, altitude: 0.0), Coordinate(49.2256004, -123.0126966, altitude: 0.0)]
    )
}
