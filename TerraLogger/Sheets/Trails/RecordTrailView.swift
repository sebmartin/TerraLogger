//
//  RecordTrailView.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-31.
//
import SwiftUI

struct RecordTrailView: View {
    private let nq = NotificationQueue.default
    
    @Environment(\.dismissSheet) var dismissSheet
    
    @State var trailName: String
    @State var property: String = ""
    @State private var formState = SubmitState.new
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Trail Details")) {
                    LabeledContent {
                        TextField("", text: $trailName)
                            .textInputAutocapitalization(.words)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    } label: {
                      Text("Trail name")
                    }
                    Picker("Property", selection: $property) {
                        Text("TODO")
                    }
                }
            }
            .disabled(!formState.editable)
            Button(action: startRecording) {
                if case .new = formState {
                    Image(systemName: "figure.hiking")
                } else {
                    ProgressView()
                }
                Text(formState.isRequesting ? "Starting..." : "Start Recording")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!formState.editable)
        }
        .onAppear() {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
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
    
    func startRecording() {
        formState = .requested
        let notification = Notification(name: .requestedStartRecordingTrail, userInfo: [
            "trailName": trailName,
            "property": property
        ])
        nq.enqueue(notification, postingStyle: .asap)
        dismissSheet?()
    }
}

fileprivate enum SubmitState {
    case new
    case requested
    case error
    
    var editable: Bool {
        if case .new = self {
            return true
        }
        return false
    }
    var isRequesting: Bool {
        if case .requested = self {
            return true
        }
        return false
    }
}

#Preview {
    RecordTrailView(trailName: "New Trail")
}
