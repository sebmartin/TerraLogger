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
                HStack {
                    Text("Name")
                    TextField("", text: $trail.name)
                        .textInputAutocapitalization(.words)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.gray)
                }
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
    
    TrailDetails(trail: Trail(name: "foo", coordinates: [], draft: false))
}
