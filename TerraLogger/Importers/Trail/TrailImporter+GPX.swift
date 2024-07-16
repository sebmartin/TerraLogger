//
//  TrailImporter+GPX.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import Foundation
import GPXKit
import os

extension TrailImporter {
    internal static func fromGPX(url: URL) throws -> [Trail] {
        let file = try Data(contentsOf: url)
        let contents = String(decoding: file, as: UTF8.self)
        let parser = GPXFileParser(xmlString: contents)
        switch parser.parse() {
        case .success(let track):
            if let trail = Trail(fromGPX: track) {
                return [trail]
            }
        case .failure(let error):
            throw error
        }
        return []
    }
}
