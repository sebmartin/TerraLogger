//
//  Logger+Importers.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import os

extension Logger {
    static let main = Logger(subsystem: Logger.subsystem, category: "main")
    static let importer = Logger(subsystem: Logger.subsystem, category: "importer")
}
