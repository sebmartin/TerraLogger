//
//  TrailImporter.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import Foundation
import os

fileprivate let logger = Logger.importer

enum ImportError: Error, CustomStringConvertible {
    case unknownError
    case unsupportedType
    case invalidUrl
    case parseError
    case notImplemented
    
    var description: String {
        switch self {
        case .unknownError: "Unknown error"
        case .unsupportedType: "Unsupported file type"
        case .invalidUrl: "Invalid URL to file"
        case .parseError: "Could not parse file contents"
        case .notImplemented: "Not implemented"
        }
    }
}

struct TrailImporter {    
    static func from(url: URL) throws(ImportError) -> [Trail] {
        do {
            switch(url.pathExtension.lowercased()) {
            case "geojson": fallthrough
            case "json":
                return try fromGeoJSON(url: url)
            case "kml": fallthrough
            case "kmz":
                return try fromKML(url: url)
            case "gpx":
                return try fromGPX(url: url)
            case _:
                throw ImportError.unsupportedType
            }
        }
        catch CocoaError.fileReadNoSuchFile {
            throw .invalidUrl
        }
        catch let error {
            logger.error("Error while importing trails from \(url) : \(error)")
            throw .unknownError
        }
    }
}
