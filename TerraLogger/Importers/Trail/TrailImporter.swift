//
//  TrailImporter.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import Foundation
import os

fileprivate let logger = Logger.importer

enum ImportError: Error {
    case unknownError
    case unsupportedType
    case invalidUrl
    case notImplemented
}

struct TrailImporter {    
    static func from(url: URL) throws(ImportError) -> [Trail] {
        do {
            switch(url.pathExtension.lowercased()) {
            case "kml":
                fallthrough
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
