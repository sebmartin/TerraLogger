//
//  RecordTrailView.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-31.
//
import SwiftUI

struct RecordTrailView: View {    
    var body: some View {
        Text("Record")
            .navigationTitle("Record")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "location.north.line")
                        Text("Record").font(.headline)
                    }
                }
            }
    }
}
