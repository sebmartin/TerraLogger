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
import os
import MapboxMaps

fileprivate let logger = Logger.main

enum SelectedFeature {
    case none
    case trail(id: PersistentIdentifier)
}

let TRAIL_DETENT_DEFAULT = PresentationDetent.height(200)

struct MapView: View {
    @Environment(\.modelContext) var context
    
    @Binding var viewport: Viewport
    @Binding var cameraState: CameraState?
    var locationProvider: AppleLocationProvider? = nil
    var completedTrails: [Trail]
    @Binding var recordingTrail: Trail?
    @Binding var boundaries: [Boundary]
    
    @State private var selectedTrail: Trail? = nil
    @State private var onCameraChangedCancellable: AnyCancelable? = nil
    @State var popoverDetent = TRAIL_DETENT_DEFAULT
        
    var body: some View {
        MapReader { mapProxy in
            Map(viewport: $viewport) {
                // Boundaries first
                ForEvery(boundaries) { boundary in
                    boundary.polygonAnnotation()
                        .fillColor(UIColor.systemBlue.withAlphaComponent(0.1))
                    
                    boundary.polylineAnnotation()
                        .lineColor(UIColor.systemBlue.withAlphaComponent(0.5))
                        .lineWidth(1.5)
                        .lineJoin(.round)
                }
                
                // Then completed trails
                PolylineAnnotationGroup(completedTrails) { trail in
                    if trail.id == selectedTrail?.id {
                        return trail.annotation.lineColor(.red)
                    } else {
                        return trail.annotation
                    }
                }
                .layerId("completed-trails")
                
                // Finally the trail currently being recorded (if any)
                if let recordingTrail = recordingTrail {
                    recordingTrail.annotation
                }
                
                TapInteraction(.layer("completed-trails")) { feature, context in
                    // Handle tap on the feature
                    if let idString = feature.id?.id, let featureId = PersistentIdentifier(jsonString: idString) {
                        selectedTrail = completedTrails.first {
                            $0.id == featureId
                        }
                        return true // Stop propagation
                    }
                    return false
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
            .popover(item: $selectedTrail, arrowEdge: .bottom) { trail in
                TrailMapSheet(trail: trail, detent: $popoverDetent)
                    .presentationDetents([TRAIL_DETENT_DEFAULT, .medium, .large], selection: $popoverDetent)
                .onDisappear { popoverDetent = TRAIL_DETENT_DEFAULT }
            }
            .onAppear {
                if let locationProvider = locationProvider {
                    mapProxy.location?.override(
                        locationProvider: locationProvider.onLocationUpdate,
                        headingProvider: locationProvider.onHeadingUpdate
                    )
                }
            }
            .task {
                // Keep track of the camera state
                if let map = mapProxy.map {
                    self.onCameraChangedCancellable = map.onCameraChanged.observe { cameraChange in
                        cameraState = map.cameraState
                    }
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
    @Previewable @State var recordingTrail: Trail? = nil
    @Previewable @State var cameraState: CameraState? = nil
    @Previewable @State var boundaries = [
        Boundary.infiniteLoop()
    ]
    let trails: [Trail] = []
    MapView(viewport: $viewport, cameraState: $cameraState, completedTrails: trails, recordingTrail: $recordingTrail, boundaries: $boundaries)
        .modelContainer(for: allModels, inMemory: true)
        .ignoresSafeArea()
}
