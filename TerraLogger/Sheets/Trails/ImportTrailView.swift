//
//  ImportTrailView.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-31.
//
import SwiftUI
import SwiftData

struct ImportTrailView: View {
    let trails: [Trail]
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Text("Import \(trails)")
            .navigationTitle("Import")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Import Trails").font(.headline)
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // TODO: accept changes
                    } label: {
                        Text("Import")
                    }

                }
            }
    }
}

//#Preview {
//    ImportTrailView(trailIdentifiers: <#T##[PersistentIdentifier]#>, dismiss: <#T##arg#>)
//}
