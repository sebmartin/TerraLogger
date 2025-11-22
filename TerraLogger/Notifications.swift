//
//  Notifications.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-10-12.
//
import Foundation

extension Notification.Name {
    // Adjust map viewport
    static let adjustMainMapViewportToPolygon = Notification.Name("adjustMainMapViewportToPolygon")
    
    // Trail recording
    static let requestedStartRecordingTrail = Notification.Name("requestedStartRecordingTrail")
    static let didStartRecordingTrail = Notification.Name("didStartRecordingTrail")
    static let failedToStartRecordingTrail = Notification.Name("failedToStartRecordingTrail")
}
