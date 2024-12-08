//
//  Binding.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-10-29.
//
import SwiftUI

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
