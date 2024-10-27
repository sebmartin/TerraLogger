//
//  environment.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-10-24.
//
import SwiftUI

struct DismissSheet: EnvironmentKey {
    static let defaultValue: DismissAction? = nil
}

extension EnvironmentValues {
    var dismissSheet: DismissAction? {
        get { self[DismissSheet.self] }
        set { self[DismissSheet.self] = newValue }
    }
}
