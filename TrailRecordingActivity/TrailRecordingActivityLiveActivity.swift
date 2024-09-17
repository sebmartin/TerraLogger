//
//  TrailRecordingActivityLiveActivity.swift
//  TrailRecordingActivity
//
//  Created by Seb Martin on 2024-09-03.
//

import ActivityKit
import WidgetKit
import SwiftUI

let redColor = UIColor.red

fileprivate extension String {
    init(duration: Duration, showSeconds: Bool = true) {
        let hours = duration.components.seconds / 60 / 60
        let minutes = duration.components.seconds / 60 % 60
        let seconds = duration.components.seconds % 60
        
        if hours > 0 {
            self.init(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            self.init(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    init(distance: Float) {
        NSLog("Setting distance to: \(distance)")
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: distance as NSNumber)
        
        self.init("\(formatted ?? "?") km")
    }
    
    init(elevation: Float) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: elevation as NSNumber)
        
        self.init("\(formatted ?? "?") m")
    }
    
    init(speed: Float) {
        self.init(format: "%.1f km/h", speed)
    }
}

fileprivate extension Text {
    init(duration: Duration) {
        let icon = Image(systemName: "timer")
        self.init("\(icon) \(String(duration: duration))")
    }
    
    init(distance: Float) {
        let icon = Image(systemName: "point.topleft.down.to.point.bottomright.curvepath.fill")
        self.init("\(icon) \(String(distance: distance))")
    }
    
    init(elevation: Float) {
        let icon = Image(systemName: "figure.stairs")
        self.init("\(icon) \(String(elevation: elevation))")
    }
    
    init(speed: Float) {
        let icon = Image(systemName: "gauge.with.dots.needle.67percent")
        self.init("\(icon) \(String(speed: speed))")
    }

    
    //arrow.up.arrow.down
}

struct TrailRecordingActivityLiveActivity: Widget {
    func toggle() {
        
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrailAttributes.self) { context in
            // Lock screen/banner UI goes here TODO
            VStack {
                Text("Hello \(context.attributes.name)")
            }
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Circle().scaledToFill().frame(width: 10, height: 10)
                            .foregroundStyle(.red)
                        Image(systemName: "figure.hiking")
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(String(duration: context.state.duration))
                        .foregroundStyle(.green)
                        .fontWeight(.semibold)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: toggle) { // Button(intent: ToggleTrailRecording())
                                Image(systemName: "pause.circle")
                                    .font(.system(size: 60))
                            }.buttonStyle(.plain)
                            Spacer()
                            VStack(alignment: .leading, spacing: 6) {
                                Text(distance: context.state.distance)
                                if let elevation = context.state.totalElevation {
                                    Text(elevation: elevation)
                                }
                                Text(speed: context.state.speed)
                            }
                            .opacity(0.9)
                            .fontWeight(.light)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            } compactLeading: {
                HStack {
                    Image(systemName: "figure.hiking")
                    Text("0:15")
                }
                .foregroundStyle(.red)
                .padding(.leading, 10)
            } compactTrailing: {
                VStack {
                    Text(String(distance: context.state.distance))
                }
            } minimal: {
                Image(systemName: "figure.hiking").foregroundStyle(.red)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TrailAttributes {
    fileprivate static var preview: TrailAttributes {
        TrailAttributes(name: "World")
    }
}

extension TrailAttributes.ContentState {
    fileprivate static var recording: TrailAttributes.ContentState {
        TrailAttributes.TrailDetails(
            distance: 12302.6,
            duration: .seconds(2 * 3600 + 12 * 60 + 61),
            totalElevation: 25.6,
            accuracy: 4,
            speed: 1.25
        )
     }
}

#Preview("Notification", as: .content, using: TrailAttributes.preview) {
   TrailRecordingActivityLiveActivity()
} contentStates: {
    TrailAttributes.ContentState.recording
//    TrailAttributes.ContentState.starEyes
}
