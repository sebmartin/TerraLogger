//
//  PersistentIdentifier+String.swift
//  TerraLogger
//
//  Created by Seb on 2025-12-04.
//
import SwiftData
import Foundation

extension PersistentIdentifier {
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8),
            let value = try? JSONDecoder().decode(PersistentIdentifier.self, from: data)
        else {
            return nil
        }
        self = value
    }
    
    func asString() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes]
        if let data = try? encoder.encode(self) {
            return String(decoding: data, as: UTF8.self)
        }
        return nil
    }
}
