//
//  Theme.swift
//  JBThemeSelector
//
//  Created by Justin Bush on 2020-12-05.
//

import Cocoa

enum Theme {
    
    case solid      // Opaque Background
    case misty      // Half & Half (Middle)
    case glass      // Translucent Blur
    
    /// Determines if the ViewController should have an opaque background or not.
    var isTransparent: Bool {
        switch self {
        case .solid: return false
        case .misty: return true
        case .glass: return true
        }
    }
    
    /// The material type of the NSVisualEffectView.
    var material: NSVisualEffectView.Material {
        switch self {
        case .solid: return .windowBackground
        case .misty: return .underWindowBackground
        case .glass: return .fullScreenUI
        }
    }
    
    var rawInt: Int {
        switch self {
        case .solid: return 0
        case .misty: return 1
        case .glass: return 2
        }
    }
}
