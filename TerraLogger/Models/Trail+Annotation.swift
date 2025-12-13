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
        let polyline = PolylineAnnotation(
            id: id.asString() ?? UUID().uuidString,
            lineCoordinates: self.coordinates.sorted().asLocationCoordinate2Ds()
        )
        
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
                .lineBorderColor(UIColor.black)
                .lineBorderWidth(2.0)
        }
    }
}
