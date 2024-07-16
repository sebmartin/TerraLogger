//
//  Importer.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-16.
//
import Foundation
import os
import SwiftData

@ModelActor actor Importer {
    public func importTrails(from url: URL) -> [PersistentIdentifier] {
        if !url.startAccessingSecurityScopedResource() {
            Logger.importer.error("Could not access file, permission denied")
            return []
        }
        do {
            let trails = try TrailImporter.from(url: url)
            trails.forEach {
                $0.draft = true
                self.modelContext.insert($0)
            }
            try modelContext.save()
            
            let trailIdentifiers = trails.map {
                $0.persistentModelID
            }
            Logger.importer.info("Imported \(trailIdentifiers.count) trail(s) with identifier(s): \(trailIdentifiers)")
            return trailIdentifiers
        } catch let error {
            Logger.importer.error("Failed to import from url: \(url.absoluteString) with error: \(error)")
            return []  // TODO: what should we do here? Raise?
        }
    }
}
