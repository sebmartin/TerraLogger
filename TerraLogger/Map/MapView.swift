//
//  MapView.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-16.
//

import Foundation
@_spi(Experimental) import MapboxMaps
import SwiftUI
import SwiftData

struct MapView: View {
    @Binding var viewport: Viewport
    var locationProvider: AppleLocationProvider? = nil

    let trails: [Trail]
    let recordingTrail: Trail?
    @Binding var boundaries: [Boundary]
            
    func followLocation(_ follow: Bool) {
        if follow {
            viewport = .followPuck(zoom: 16.5, bearing: .heading, pitch: 60)
        } else {
            viewport = .idle
        }
    }
        
    @Environment(\.modelContext) var context
    
    var body: some View {
        MapReader { mapProxy in
            Map(viewport: self.$viewport) {
                // Boundaries first
                ForEvery(boundaries) { boundary in
                    boundary.polygonAnnotation()
                        .fillColor(UIColor.systemBlue.withAlphaComponent(0.1))
                    
                    boundary.polylineAnnotation()
                        .lineColor(UIColor.systemBlue.withAlphaComponent(0.5))
                        .lineWidth(1.5)
                        .lineJoin(.round)
                }
                
                // Trails second (on top of boundaries)
                ForEvery(trails) { trail in
                    PolylineAnnotation(lineCoordinates: trail.coordinates.sorted().map {
                        CLLocationCoordinate2D(coordinate: $0)
                    })
                    .lineColor(UIColor.systemBlue.withAlphaComponent(0.9))
                    .lineWidth(2.5)
                    .lineJoin(.round)
                }
                
                if let recordingTrail = recordingTrail {
                    PolylineAnnotation(lineCoordinates: recordingTrail.coordinates.sorted().map {
                        CLLocationCoordinate2D(coordinate: $0)
                    })
                    .lineColor(UIColor.systemRed.withAlphaComponent(0.9))
                    .lineWidth(2.5)
                    .lineJoin(.round)
                }
                
                // User position is last to render above other annotations
                Puck2D(bearing: .heading)
                    .showsAccuracyRing(true)
            }
            .mapStyle(MapStyle(uri: StyleURI(rawValue: "mapbox://styles/sebmartin/cl0daly1b002j15ldl6d0xcmh")!))
            .ornamentOptions(
                .init(
                    scaleBar: .init(position: .bottomRight, margins: .init(x: 40, y: -22), useMetricUnits: true),
                    compass: .init(margins: .init(x: 15, y: 180)),
                    logo: .init(position: .bottomLeft, margins: CGPoint(x: 40, y: -25)),
                    attributionButton: .init(position: .bottomRight, margins: CGPoint(x: 0, y: 1000))
                )
            )
            .onAppear {
                if let locationProvider = locationProvider {
                    mapProxy.location?.override(
                        locationProvider: locationProvider.onLocationUpdate,
                        headingProvider: locationProvider.onHeadingUpdate
                    )
                }
            }
        }
    }
    
    
}

#Preview {
    @Previewable @State var viewport = Viewport.overview(
        geometry: MultiPoint(
            [
                // Infinite Loop
                LocationCoordinate2D(latitude: 37.333967, longitude: -122.031858),
                LocationCoordinate2D(latitude: 37.33070456, longitude: -122.01970909),
            ]
        ),
        geometryPadding: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    )
    @Previewable @State var boundaries = [
        Boundary.infiniteLoop()
    ]
    let trails: [Trail] = []
    MapView(viewport: $viewport, trails: trails, recordingTrail: nil, boundaries: $boundaries)
        .modelContainer(for: allModels, inMemory: true)
        .ignoresSafeArea()
}
