//
//  TrailRecordingActivityBundle.swift
//  TrailRecordingActivity
//
//  Created by Seb Martin on 2024-09-03.
//

import WidgetKit
import SwiftUI

@main
struct TrailRecordingActivityBundle: WidgetBundle {
    var body: some Widget {
        TrailRecordingActivityControl()
        TrailRecordingActivityLiveActivity()
    }
}
