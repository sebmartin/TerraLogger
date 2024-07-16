//
//  TrailImporter+KML.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import Foundation
import RCKML

extension TrailImporter {
    internal static func fromKML(url: URL) throws -> [Trail] {
        let doc = try KMLDocument(url)
        
        // Flatten the document by traversing folders (if any)
        func flatten(features: [KMLFeature]) -> [KMLFeature] {
            var flattened = [KMLFeature]()
            for feature in features {
                if let folder = feature as? KMLFolder {
                    flattened.append(contentsOf: flatten(features: folder.features))
                } else {
                    flattened.append(feature)
                }
            }
            return flattened
        }
        
        return flatten(features: doc.features)
            .compactMap {
                if let placemark = ($0 as? KMLPlacemark), placemark.isTrailCompatible() {
                    return Trail(fromPlacemark: placemark)
                }
                return nil
            }
    }
}

extension KMLPlacemark {
    func isTrailCompatible() -> Bool {
        /// Returns `true` if placemark can be considered a "trail"
        if let _ = self.geometry as? KMLLineString {
            return true
        }
        return false
    }
}
