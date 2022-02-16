//
//  BindigExtension.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 24.01.22.
//
// import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
