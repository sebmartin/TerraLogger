//
//  Double+rounded.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-11-02.
//
import Foundation

extension Double {
    public func rounded(decimals: Int) -> Double {
        let factor = Double.pow(10, decimals)
        return (self * factor).rounded() / factor
    }
}
