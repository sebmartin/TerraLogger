//
//  Trail+Annotatable.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-17.
//
@_spi(Experimental)
import MapboxMaps
import SwiftUI


extension Trail {
    var annotation: PolylineAnnotation {
        let polyline = PolylineAnnotation(lineCoordinates: self.coordinates.sorted().map {
            CLLocationCoordinate2D(coordinate: $0)
        })
        
        return switch (status) {
        case .recording:
            polyline
                .lineColor(UIColor.systemRed.withAlphaComponent(0.9))
                .lineJoin(.round)
                .lineWidth(9.0)
                .lineBorderColor(UIColor.darkGray)
                .lineBorderWidth(2.0)
        default:
            polyline
                .lineColor(UIColor.systemBlue.withAlphaComponent(0.9))
                .lineJoin(.round)
                .lineWidth(8.0)
        }
    }
}
