//
//  Bundle+Test.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-08-11.
//
import Foundation

fileprivate class __TestClass__ {}

extension Bundle {
    static var test: Bundle {
        get {
            return Bundle(for: __TestClass__.self)
        }
    }
}
