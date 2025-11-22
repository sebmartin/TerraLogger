//
//  MapButton.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-29.
//

import SwiftUI

struct MapButton: View {
    let size: CGFloat
    let systemName: String
    private let action: (() -> ())?
    
    init(_ systemName: String, size: Float = 20.0, action: (() -> ())? = nil) {
        self.size = CGFloat(size)
        self.systemName = systemName
        self.action = action
    }
        
    var body: some View {
        Button(action: {
            action?()
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: size * 2.0, height: size * 2.0)
                Image(systemName: systemName)
                    .font(.system(size: size))
                    .padding(.all, 40)
                    .frame(width: size * 2.0, height: size * 2.0)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        MapButton("heart.fill")
        MapButton("point.bottomleft.forward.to.arrow.triangle.scurvepath", size: 40.0).foregroundColor(.red)
        MapButton("point.topleft.down.to.point.bottomright.curvepath", size: 80.0)
        HStack {
            MapButton("location.circle")
            MapButton("map")
            Spacer()
            MapButton("point.bottomleft.forward.to.arrow.triangle.scurvepath")
            MapButton("mappin.and.ellipse")
            MapButton("heart")
            MapButton("ellipsis")
        }.padding(20)
    }
}
