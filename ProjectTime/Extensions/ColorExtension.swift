//
//  ColorExtension.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 15.11.21.
//

import SwiftUI

extension Color {
    // The system grouped background color is the light gray
    //color you can see in the background of the Settings app
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    
    // secondary system grouped background is designed to be layered on top
    // of the regular grouped background and so will be brighter.
    // These colors are dark mode aware, so you might see
    // them as black and dark gray.

    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
}
