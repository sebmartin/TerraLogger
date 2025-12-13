//
//  TrailSheet.swift
//  TerraLogger
//
//  Created by Seb on 2025-12-07.
//
import SwiftUI

struct TrailMapSheet: View {
    let trail: Trail
    @Binding var detent: PresentationDetent
    @State var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            TrailDetailsPreview(trail: trail, detent: $detent, navPath: $navPath)
                .navigationDestination(for: Trail.self) { trail in
                    TrailDetails(trail: trail)
                }
        }
    }
}
