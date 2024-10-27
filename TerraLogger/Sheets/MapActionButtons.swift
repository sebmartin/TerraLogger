//
//  SheetButtons.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-30.
//

import SwiftUI

struct MapActionButtons: View {
    @Binding var presentedSheet: MapSheet?
    
    var body: some View {
        HStack {
            Spacer()
            MapButton("point.bottomleft.forward.to.arrow.triangle.scurvepath") {
                presentedSheet = .trails
            }
            Spacer()
            MapButton("mappin.and.ellipse") {
                presentedSheet = .pins
            }
            Spacer()
            MapButton("heart") {
                presentedSheet = .favourites
            }
            Spacer()
            MapButton("ellipsis") {
                presentedSheet = .menu
            }
            Spacer()
        }
    }
}
