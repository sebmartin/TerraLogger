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
    
    init(trail: Trail) {
        self.trail = trail
    }
    var body: some View {
        Form {
            Section(header: Text("Trail Details")) {
                LabeledContent("Name") {
                    TextField("Name", text: $trail.name)
                        .textInputAutocapitalization(.words)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.gray)
                }
                LabeledContent("Status", value: trail.status.rawValue)
            }
        }
        .onAppear() {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}

#Preview {
    //    let url = Bundle.main.url(forResource: "trails.trail-of-hope", withExtension: "gpx")!
    //    let trails = try! TrailImporter.from(url: url)
    
    TrailDetails(trail: Trail(name: "foo", coordinates: [], status: .complete, source: .unknown))
}
