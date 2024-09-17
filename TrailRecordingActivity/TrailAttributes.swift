//
//  TrailAttributes.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-09-03.
//
import ActivityKit

struct TrailAttributes: ActivityAttributes, Sendable {
    typealias ContentState = TrailDetails
    
    struct TrailDetails: Codable, Hashable {
        let distance: Float // meters
        let duration: Duration
        let totalElevation: Float? // meters
        let accuracy: Int?
        let speed: Float // meters/second
    }
    
    var name: String
}
