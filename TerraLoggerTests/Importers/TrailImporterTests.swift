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
