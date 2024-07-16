//
//  Trail.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-06.
//
import SwiftData
import Foundation

@Model
final class Trail {
    var name: String
    var draft: Bool
    var createdAt: Date
    var startedAt: Date?
    var endedAt: Date?
    var notes: String
    
    @Relationship(deleteRule: .cascade) var coordinates: [Coordinate]
    
    init(name: String, coordinates: [Coordinate], draft: Bool = true, startedAt: Date? = nil, endedAt: Date? = nil) {
        self.name = name
        self.draft = draft
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.createdAt = Date.now
        self.notes = ""
        self.coordinates = coordinates
    }
}
