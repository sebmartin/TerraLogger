//
//  TrailDetailsPreview.swift
//  TerraLogger
//
//  Created by Seb on 2025-12-04.
//

import SwiftUI

struct TrailDetailsPreview: View {
    @State var trail: Trail
    @Binding var detent: PresentationDetent
    @Binding var navPath: NavigationPath
    
    var body: some View {
        VStack {
            Text(trail.name)
        }
        .navigationTitle(trail.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    navPath.append(trail)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        detent = .large
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}
