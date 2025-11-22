//
//  Coordinate+Array.swift
//  TerraLogger
//
//  Created by Seb Martin on 2025-11-21.
//

import MapboxMaps
import CoreLocation

extension Array where Element == Coordinate {

    func squareBoundingPolygon(padding: Double = 0.0) -> Polygon? {
        guard !self.isEmpty else { return nil }

        // ---- 1. Basic min/max ----
        guard let minLat = self.map(\.latitude).min(),
              let maxLat = self.map(\.latitude).max(),
              let minLon = self.map(\.longitude).min(),
              let maxLon = self.map(\.longitude).max()
        else {
            return nil
        }

        // ---- 2. Center ----
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2

        // ---- 3. Dimensions (longitude scaled for latitude) ----
        let height = maxLat - minLat
        let widthAdjusted = (maxLon - minLon) * cos(centerLat * .pi/180)

        // ---- 4. Square side ----
        var side = Swift.max(height, widthAdjusted)

        // Optional padding in degrees (same units as side)
        side += padding * 2

        let halfSide = side / 2

        // Expand lat
        let squareMinLat = centerLat - halfSide
        let squareMaxLat = centerLat + halfSide

        // Expand lon (convert back from widthAdjusted units)
        let lonSideDegrees = halfSide / cos(centerLat * .pi/180)
        let squareMinLon = centerLon - lonSideDegrees
        let squareMaxLon = centerLon + lonSideDegrees

        // ---- 5. Build polygon ----
        let sw = CLLocationCoordinate2D(latitude: squareMinLat, longitude: squareMinLon)
        let se = CLLocationCoordinate2D(latitude: squareMinLat, longitude: squareMaxLon)
        let ne = CLLocationCoordinate2D(latitude: squareMaxLat, longitude: squareMaxLon)
        let nw = CLLocationCoordinate2D(latitude: squareMaxLat, longitude: squareMinLon)

        return Polygon([ [sw, se, ne, nw, sw] ])
    }
}
