//
//  TrailRecorder.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-31.
//

import os
import Combine
import SwiftUI
import MapboxMaps
import ActivityKit
import SwiftData

fileprivate let logger = Logger.importer

fileprivate enum RecordingState {
    case stopped
    case starting
    case recording(TrailRecorder.TrailRecorderActor, CLLocationManager)
    case stopping
}

@MainActor
class TrailRecorder: NSObject, CLLocationManagerDelegate {

    @Published private(set) var isRecording = false
    
    fileprivate var state: RecordingState = .stopped {
        didSet {
            switch(state) {
            case .recording(_, _):
                self.isRecording = true
            case .stopped:
                self.isRecording = false
            default:
                break
            }
        }
    }
    
    func startRecording(trailName: String, modelContainer: ModelContainer) async -> PersistentIdentifier? {
        guard case .stopped = state else {
            let state = String(describing: state)
            logger.warning("Tried to start recording while state = \(state)")
            return nil
        }
        
        logger.info("Starting recorder for trail named: \(trailName)")
        state = .starting
        let task = Task.detached {
            let recorder = TrailRecorderActor(modelContainer: modelContainer)
            return recorder
        }
        let trailRecorder = await task.result.get()
        let trailId = await trailRecorder.recordNewTrail(name: trailName)
        
        // Check if we attempted to stop recording while we were setting up
        if case .stopping = state {
            await self.stopRecording()
        } else {
            logger.info("Now recording locations for trail named: \(trailName)")

            let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            state = .recording(trailRecorder, locationManager)
        }
        return trailId
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            await didReceive(locationUpdates: locations)
        }
    }
    
    func didReceive(locationUpdates locations: [CLLocation]) async {
        guard case .recording(let trailRecorder, _) = state else {
            return
        }
        Task {
            await trailRecorder.append(locations: locations)
        }
    }
    
    func stopRecording() async {
        switch(state) {
        case .stopped:
            logger.info("Tried to stop recording while already stopped, ignoring.")
            return
        case .stopping:
            break
        case .recording(let trailRecorder, let locationManager):
            locationManager.stopUpdatingLocation()
            await trailRecorder.finishRecording()
            state = .stopped
            logger.info("Trail recording has stopped.")
            break
        case .starting:
            logger.info("Requested to stop recording while recorder is starting, will try to stop it when done initializing")
            state = .stopping
        }
    }
    
    @ModelActor
    fileprivate actor TrailRecorderActor {
        var trail: Trail? = nil
        
        var lastLocation: Coordinate? = nil
        var totalDistance: Double = 0.0
        
        func recordNewTrail(name trailName: String) -> PersistentIdentifier {
            if let trail = trail {
                logger.warning("TrailRecorder is already recording a trail, ignoring.")
                return trail.persistentModelID
            }
            
            // Create the trail
            let trail = Trail(name: trailName, coordinates: [], status: .recording, source: .imported)
            self.modelContext.insert(trail)
            try? self.modelContext.save()
            self.trail = trail
            self.totalDistance = 0.0
            self.lastLocation = nil
            
            return trail.persistentModelID
        }
        
        private func startLiveActivity() {
            do {
                let attributes = TrailAttributes(name: "New Trail")
                let initialState = TrailAttributes.ContentState(
                    distance: 0.0, duration: .seconds(0), totalElevation: 0.0, accuracy: 0, speed: 0
                )
                let activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: nil
                )
                logger.info("Started live activity with id: \(activity.id)")
            } catch {
                print("Error starting live activity: \(error.localizedDescription)")
            }
        }
        
        func finishRecording() {
            if let trail = trail {
                trail.status = .complete
                try? self.modelContext.save()
            }
            trail = nil
        }
        
        // MARK: - Location updates
        
        func append(locations: [CLLocation]) async {
            var coordinates = [Coordinate]()
            for location in locations {
                logger.info("location: \(location)")
                let coord = Coordinate(from: location)
                if let lastLocation = self.lastLocation {
                    let distance = coord.distance(to: lastLocation)
                    if distance < 2 /* meters */ {
                        // Another option is to batch saves every ~1 second
                        logger.info("Skipping location, distance is too short: \(distance)")
                        return
                    }
                    totalDistance += distance
                    logger.info("distance: \(distance), total: \(self.totalDistance)")
                }
                coordinates.append(coord)
                self.lastLocation = coord
            }
            
            if let trail = self.trail {
                logger.info("Saving \(coordinates.count) new coordinates")
                trail.coordinates.append(contentsOf: coordinates)
                do {
                    try self.modelContext.save()
                } catch {
                    logger.error("Could not save location: \(error)")
                }
            }
        }
    }
}
