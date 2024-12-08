//
//  RecordMapControl.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-10-26.
//
import SwiftUI
import MapboxMaps

struct RecordingMapControl: View {
    @Binding var trail: Trail?
    var trailRecorder: TrailRecorder
    
    var isRecording: Bool {
        trailRecorder.isRecording
    }
    
    @State var duration = Duration.zero
    @State var distance: Double = 0
    
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
                        Text(duration.formatted())  // duration
                        Spacer()
                        Text(" • ")
                        Spacer()
                        Text(distance.formattedDistance())
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
        .onReceive(trailRecorder.$trailStats) { stats in
            duration = stats.duration
            distance = stats.distance
        }
    }
}

fileprivate extension Double {
    func formattedDistance() -> String {
        if self < 1000 {
            return String(format: "%d m", Int(self))
        } else {
            return String(format: "%.2f km", self / 1000.0)
        }
    }
}

#Preview {
    @Previewable @State var isHidden = false
    @Previewable @State var trail: Trail? = Trail(name: "Beautiful New Trail", coordinates: [], status: .recording, source: .recorded, startedAt: nil, endedAt: nil)
    let trailRecorder = TrailRecorder()
    VStack {
        Spacer()
        RecordingMapControl(
            trail: $trail,
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

