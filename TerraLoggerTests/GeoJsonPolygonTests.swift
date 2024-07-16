//
//  GeoJsonPolygonTests.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-24.
//

import Testing
import Foundation
@testable import TerraLogger


struct GeoJsonPolygonTests {
    @Test
    func convertsGeoJson() async throws {
        let url = Bundle.main.url(forResource: "boundary", withExtension: "geojson")!
        let geoJson = GeoJsonPolygon(url: url)
    }
}
