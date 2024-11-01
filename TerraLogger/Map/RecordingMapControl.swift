//
//  RecordMapControl.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-10-26.
//
import SwiftUI
import MapboxMaps

struct RecordingMapControl: View {
    var trail: Trail?
    var trailRecorder: TrailRecorder
    
    var isRecording: Bool {
        trailRecorder.isRecording
    }
    
    var body: some View {
        HStack {
            if trail != nil {
                VStack(alignment: .leading) {
                    HStack {
                        Text(trail?.name ?? "")
                            .font(.system(.title3, weight: .medium))
                            .lineLimit(0)
                        Image(systemName: "chevron.right")
                            .opacity(0.4)
                    }
                    HStack {
                        Spacer()
                        Text("3:45:01")  // duration
                        Spacer()
                        Text(" • ")
                        Spacer()
                        Text("5.6 km")  // distance
                        Spacer()
                        Text(" • ")
                        Spacer()
                        Text("200 m")  // elevation
                        Spacer()
                    }
                    .font(.system(.subheadline, weight: .light))
                }
                .padding(.leading, 20)
            }
            Spacer()
            MapButton("stop.fill") {
                Task {
                    await trailRecorder.stopRecording()
                }
            }
            .foregroundStyle(.red)
            .background(Circle().fill(.regularMaterial))
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(.thinMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .onTapGesture {
            // Go to the trail details page
            print("asdf asdf")
        }
    }
}

#Preview {
    @Previewable @State var isHidden = false
    @Previewable @State var trail = Trail(name: "Beautiful New Trail", coordinates: [], status: .recording, source: .recorded, startedAt: nil, endedAt: nil)
    let trailRecorder = TrailRecorder()
    VStack {
        Spacer()
        RecordingMapControl(
            trail: trail,
            trailRecorder: trailRecorder
        )
            .frame(height: 80)
            .padding(20)
            .offset(CGSize(width: 0, height: isHidden ? 100 : 0))
            .opacity(isHidden ? 0 : 1)
            .animation(.easeInOut(duration: 0.25), value: isHidden)
        Spacer()
        Button("Toggle Visibility") {
            isHidden = !isHidden
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, 10)
    }
    .containerRelativeFrame([.horizontal, .vertical])
    .background {
        Rectangle().fill(.green)
    }
}

