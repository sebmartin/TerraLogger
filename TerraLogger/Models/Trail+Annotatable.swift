//
//  Trail+Annotatable.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-17.
//
@_spi(Experimental)
import MapboxMaps

extension Trail: Annotatable {
    var annotation: any MapContent {
        return PolylineAnnotation(lineString: LineString([]))
    }
}
