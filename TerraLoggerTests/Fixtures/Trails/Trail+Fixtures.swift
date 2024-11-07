//
//  Trail+Fixtures.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-11-02.
//
import Foundation
@testable import TerraLogger

internal struct Trails {
    private static let randomDate = Date(timeIntervalSince1970: 1730520647.7777882)
    
    static let trailOfHope = Trail(
        name: "Vancouver Central Park - Trail of Hope",
        coordinates: [Coordinate(49.22924, -123.02349, altitude: 0.0), Coordinate(49.22908, -123.02323, altitude: 0.0), Coordinate(49.22887, -123.023, altitude: 0.0), Coordinate(49.22875, -123.02284, altitude: 0.0), Coordinate(49.22873, -123.02259, altitude: 0.0), Coordinate(49.22873, -123.022, altitude: 0.0), Coordinate(49.22871, -123.02179, altitude: 0.0), Coordinate(49.22861, -123.0215, altitude: 0.0), Coordinate(49.22847, -123.02118, altitude: 0.0), Coordinate(49.22842, -123.02113, altitude: 0.0), Coordinate(49.22825, -123.02072, altitude: 0.0), Coordinate(49.22808, -123.02027, altitude: 0.0), Coordinate(49.22788, -123.01962, altitude: 0.0), Coordinate(49.22766, -123.01925, altitude: 0.0), Coordinate(49.22749, -123.019, altitude: 0.0), Coordinate(49.22722, -123.01844, altitude: 0.0), Coordinate(49.22699, -123.01798, altitude: 0.0), Coordinate(49.2267437, -123.0174861, altitude: 0.0), Coordinate(49.2265, -123.01676, altitude: 0.0), Coordinate(49.226, -123.01535, altitude: 0.0), Coordinate(49.2259237, -123.015135, altitude: 0.0), Coordinate(49.2259, -123.01492, altitude: 0.0), Coordinate(49.22579, -123.01431, altitude: 0.0), Coordinate(49.22575, -123.01402, altitude: 0.0), Coordinate(49.22568, -123.01366, altitude: 0.0), Coordinate(49.22565, -123.01304, altitude: 0.0), Coordinate(49.2256004, -123.0126966, altitude: 0.0)],
        status: TrailStatus.complete,
        source: TrailSource.imported
    )
    
    static let tinyTrail = Trail(
        name: "Vancouver Central Park - Trail of Hope",
        coordinates: [
            Coordinate(49.22924, -123.02349, altitude: 1.0, recordedAt: Date(timeInterval: 0.0, since: randomDate)),
            Coordinate(49.22908, -123.02323, altitude: 2.1, recordedAt: Date(timeInterval: 45.0, since: randomDate)),
            Coordinate(49.22887, -123.023, altitude: 1.2, recordedAt: Date(timeInterval: 92.5, since: randomDate)),
            Coordinate(49.22875, -123.02284, altitude: 1.5, recordedAt: Date(timeInterval: 125.0, since: randomDate))],
        status: TrailStatus.complete,
        source: TrailSource.imported
    )
}
