//
//  Trail+GPX.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-12.
//
import GPXKit

extension Trail {
    convenience init?(fromGPX track: GPXTrack) {
        self.init(
            name: track.title, coordinates: track.trackPoints.enumerated().compactMap { order, point in
                Coordinate(from: point, order: order)
            }
        )
    }
}
