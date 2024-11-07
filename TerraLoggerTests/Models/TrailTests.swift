//
//  TrailTests.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-11-01.
//

import Testing
@testable import TerraLogger

let expectedStats = TrailStats(
    duration: Duration.seconds(125.0),
    distance: 72.34,
    elevationGain: 1.4
)

struct TrailTests {
    @Test("Can generate stats")
    func trailStats() async throws {
        let trail = Trails.tinyTrail
        
        let stats = trail.stats
        #expect(stats.duration == expectedStats.duration)
        #expect(stats.distance.rounded(decimals: 2) == expectedStats.distance.rounded(decimals: 2))
        #expect(stats.elevationGain.rounded(decimals: 2) == expectedStats.elevationGain.rounded(decimals: 2))
    }
    
    @Test("Can update stats with newer coordinates -- one at a time")
    func udpatedStatsIndividual() async throws {
        let trail = Trails.tinyTrail
        let coords = trail.coordinates
        trail.coordinates = []
        
        var stats = trail.stats
        for coord in coords {
            stats = stats.updated(with: [coord])
        }
        
        #expect(stats.duration == expectedStats.duration)
        #expect(stats.distance.rounded(decimals: 2) == expectedStats.distance.rounded(decimals: 2))
        #expect(stats.elevationGain.rounded(decimals: 2) == expectedStats.elevationGain.rounded(decimals: 2))
    }
    
    @Test("Can update stats with newer coordinates -- chunks")
    func udpatedStatsChunks() async throws {
        let trail = Trails.tinyTrail
        let coords = trail.coordinates
        trail.coordinates = []
        let chunks = [
            coords[0...1],
            coords[1...]
        ]
        
        var stats = trail.stats
        for chunk in chunks {
            stats = stats.updated(with: Array(chunk))
        }
        
        #expect(stats.duration == expectedStats.duration)
        #expect(stats.distance.rounded(decimals: 2) == expectedStats.distance.rounded(decimals: 2))
        #expect(stats.elevationGain.rounded(decimals: 2) == expectedStats.elevationGain.rounded(decimals: 2))
    }
    
    @Test("Can update stats with newer coordinates -- empty list")
    func udpatedStatsEmptyList() async throws {
        let trail = Trails.tinyTrail
        
        var stats = trail.stats
        stats = stats.updated(with: [])
        
        #expect(stats.duration == expectedStats.duration)
        #expect(stats.distance.rounded(decimals: 2) == expectedStats.distance.rounded(decimals: 2))
        #expect(stats.elevationGain.rounded(decimals: 2) == expectedStats.elevationGain.rounded(decimals: 2))
    }
}
