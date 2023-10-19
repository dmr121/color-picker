//
//  ColorCombination.swift
//  Color Picker
//
//  Created by David Rozmajzl on 10/19/23.
//

import Foundation

// Numbers string order is sorted by angles most clockwise
// relative to the main selected color
enum ColorCombination: String, CaseIterable, Identifiable {
    case single
    case complementary = "180"
    case analogous = "45,-45"
    case triadic = "120,-120"
    case tetradic = "90,180,-90"
    
    var id: Self {
        return self
    }
    
    var angles: [CGFloat] {
        guard self != .single else { return [] }
        return rawValue.split(separator: ",").map { floatString in
            let float = (floatString as NSString).floatValue
            return CGFloat(float)
        }
    }
    
    var label: String {
        switch self {
        case .single:
            return "Single"
        case .complementary:
            return "Complementary"
        case .analogous:
            return "Analogous"
        case .triadic:
            return "Triadic"
        case .tetradic:
            return "Tetradic"
        }
    }
    
    var systemSymbolName: String {
        switch self {
        case .single:
            return "die.face.1.fill"
        case .complementary:
            return "die.face.2.fill"
        case .analogous:
            return "die.face.2"
        case .triadic:
            return "die.face.3.fill"
        case .tetradic:
            return "die.face.4.fill"
        }
    }
}
