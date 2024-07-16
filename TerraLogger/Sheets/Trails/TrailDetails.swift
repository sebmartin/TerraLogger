//
//  TrailDetails.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-06.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct TrailDetails: View {
    @State private var trail: Trail
    @State var viewport = Viewport.overview(
        geometry: MultiPoint(
            [LocationCoordinate2D(latitude: 46.03338, longitude: -75.57854),
            LocationCoordinate2D(latitude: 46.04051, longitude: -75.55748)]
        ),
        geometryPadding: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    )
    
    init(trail: Trail) {
        self.trail = trail
    }
    var body: some View {
        Form {
            Section(header: Text("Trail Details")) {
                HStack {
                    Text("Name")
                    TextField("", text: $trail.name)
                        .textInputAutocapitalization(.words)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.gray)
                }
            }
//            Section(header: Text("Preview")) {
//                MapView(viewport: $viewport, trails: [trail])
//            }
        }
        .onAppear() {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}

#Preview {
    //    let url = Bundle.main.url(forResource: "trails.trail-of-hope", withExtension: "gpx")!
    //    let trails = try! TrailImporter.from(url: url)
    
    TrailDetails(trail: Trail(name: "foo", coordinates: [], draft: false))
}
