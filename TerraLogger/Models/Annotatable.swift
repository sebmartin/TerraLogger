//
//  Annotatable.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-17.
//
@_spi(Experimental)
import MapboxMaps

/// Represents a type that can be displayed on a Mapbox map as an annotation. The `annotation` property should return
/// a `MapboxMaps.Annotation` type that represents the model.
protocol Annotatable {
    
    /// Returns an instance of a `MapboxMaps.Annotation` representing the model
    var annotation: any MapContent {
        get
    }
}
