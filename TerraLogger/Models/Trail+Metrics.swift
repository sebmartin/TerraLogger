//
//  Trail+Metrics.swift
//  TerraLogger
//
//  Created by Seb on 2025-12-07.
//
import Turf

extension Trail {
    
    var distance: Double {
        let sortedCoords = coordinates.sorted().asLocationCoordinate2Ds()
        guard let firstCoord = sortedCoords.first else {
            return 0.0
        }
        let initialValue = (distance: 0.0, lastCoordinate: firstCoord)
        return sortedCoords.reduce(initialValue) { result, coord in
            return (
                distance: result.distance + result.lastCoordinate.distance(to: coord),
                lastCoordinate: coord
            )
        }.distance
    }
}
