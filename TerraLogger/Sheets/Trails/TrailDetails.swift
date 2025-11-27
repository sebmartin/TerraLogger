//
//  TrailDetails.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-06.
//
import Foundation
import SwiftUI
@_spi(Experimental) import MapboxMaps

struct TestTransferable: Transferable {
    let data: Data
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            return item.data
        }
    }
}

struct TrailDetails: View {
    @State private var trail: Trail
    @State private var requestExport = false
    @State private var showExportShareSheet = false
    
    private let nq = NotificationQueue.default
    @Environment(\.dismissSheet) var dismissSheet
    @Environment(\.modelContext) private var modelContext
    
    let exportIcon = Image("trailIcon", bundle: Bundle.main)
    
    init(trail: Trail) {
        self.trail = trail
    }
    
    var viewport: Viewport {
        guard let squarePolygon = trail.coordinates.squareBoundingPolygon() else {
            return .idle
        }

        return .overview(
            geometry: squarePolygon,
            geometryPadding: EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50)
        )
    }

    func centerTrailOnMap() {
        if let polygon = trail.coordinates.squareBoundingPolygon() {
            let notification = Notification(name: .adjustMainMapViewportToPolygon, userInfo: [
                "polygon": polygon,
            ])
            nq.enqueue(notification, postingStyle: .asap)
        }
        dismissSheet?()
    }
    
    func exportTrail() {
        requestExport = true
    }
    
    var body: some View {
        Form {
            Section(header: Text("Trail Details")) {
                LabeledContent {
                    TextField("Name", text: $trail.name)
                        .textInputAutocapitalization(.words)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.gray)
                } label: {
                    Text("Name")
                }
                LabeledContent("Status", value: trail.status.rawValue.capitalized)
                Toggle(isOn: $trail.visible) {
                    Text("Visible")
                }
                if trail.coordinates.count > 0 {
                    Map(initialViewport: viewport) {
                        trail.annotation
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
                        .disabled(true)
                        .aspectRatio(1, contentMode: .fit)
                }
                    
            }
            Button("Center on Map", systemImage: "dot.viewfinder", action: centerTrailOnMap)
            Button("Share", systemImage: "square.and.arrow.up") { showExportShareSheet = !showExportShareSheet }
            .confirmationDialog("Select a format", isPresented: $showExportShareSheet) {
                ShareLink(
                    "GeoJSON",
                    item: trail.geoJsonTransferable(modelContainer: modelContext.container),
                    preview: SharePreview(trail.name, image: exportIcon)
                )
                ShareLink(
                    "KML",
                    item: trail.kmlTransferable(modelContainer: modelContext.container),
                    preview: SharePreview(trail.name, image: exportIcon)
                )
                ShareLink(
                    "KMZ",
                    item: trail.kmzTransferable(modelContainer: modelContext.container),
                    preview: SharePreview(trail.name, image: exportIcon)
                )
                ShareLink(
                    "GPX",
                    item: trail.gpxTransferable(modelContainer: modelContext.container),
                    preview: SharePreview(trail.name, image: exportIcon)
                )
            }
        }
        .navigationTitle("Trail Details")
        .onAppear() {
            UITextField.appearance().clearButtonMode = .whileEditing
            print(trail.coordinates.sorted(by: { $0.createdAt < $1.createdAt }))
        }
    }
}

#Preview {
    TrailDetails(trail: Trail(name: "Marvelous Trail", coordinates: [Coordinate(49.22924, -123.02349, altitude: 0.0), Coordinate(49.22908, -123.02323, altitude: 0.0), Coordinate(49.22887, -123.023, altitude: 0.0), Coordinate(49.22875, -123.02284, altitude: 0.0), Coordinate(49.22873, -123.02259, altitude: 0.0), Coordinate(49.22873, -123.022, altitude: 0.0), Coordinate(49.22871, -123.02179, altitude: 0.0), Coordinate(49.22861, -123.0215, altitude: 0.0), Coordinate(49.22847, -123.02118, altitude: 0.0), Coordinate(49.22842, -123.02113, altitude: 0.0), Coordinate(49.22825, -123.02072, altitude: 0.0), Coordinate(49.22808, -123.02027, altitude: 0.0), Coordinate(49.22788, -123.01962, altitude: 0.0), Coordinate(49.22766, -123.01925, altitude: 0.0), Coordinate(49.22749, -123.019, altitude: 0.0), Coordinate(49.22722, -123.01844, altitude: 0.0), Coordinate(49.22699, -123.01798, altitude: 0.0), Coordinate(49.2267437, -123.0174861, altitude: 0.0), Coordinate(49.2265, -123.01676, altitude: 0.0), Coordinate(49.226, -123.01535, altitude: 0.0), Coordinate(49.2259237, -123.015135, altitude: 0.0), Coordinate(49.2259, -123.01492, altitude: 0.0), Coordinate(49.22579, -123.01431, altitude: 0.0), Coordinate(49.22575, -123.01402, altitude: 0.0), Coordinate(49.22568, -123.01366, altitude: 0.0), Coordinate(49.22565, -123.01304, altitude: 0.0), Coordinate(49.2256004, -123.0126966, altitude: 0.0)], status: .complete, source: .unknown))
}

