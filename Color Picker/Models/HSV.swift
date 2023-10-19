//
//  HSV.swift
//  Color Picker
//
//  Created by David Rozmajzl on 10/19/23.
//

import SwiftUI

/// This was all taken from here and only slightly edited. -> https://gist.github.com/FredrikSjoberg/cdea97af68c6bdb0a89e3aba57a966ce

/// Struct that holds hue, saturation, value values. Also has a `rgb` value that converts it's values to hsv.
struct HSV {
    private(set) var h: CGFloat // Angle in degrees
    private(set) var s: CGFloat // Percent [0,1]
    private(set) var v: CGFloat // Percent [0,1]
    
    static func toRGB(h: CGFloat, s: CGFloat, v: CGFloat) -> RGB {
        if s == 0 { return RGB(r: v, g: v, b: v) } // Achromatic grey
        
        var angle = (h.truncatingRemainder(dividingBy: 360))
        if angle < 0 {
            angle += 360
        }
    
        let sector = angle / 60 // Sector
        let i = floor(sector)
        let f = sector - i // Factorial part of h
        
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))
        
        switch(i) {
        case 0:
            return RGB(r: v, g: t, b: p)
        case 1:
            return RGB(r: q, g: v, b: p)
        case 2:
            return RGB(r: p, g: v, b: t)
        case 3:
            return RGB(r: p, g: q, b: v)
        case 4:
            return RGB(r: t, g: p, b: v)
        default:
            return RGB(r: v, g: p, b: q)
        }
    }
    
    var rgb: RGB {
        return HSV.toRGB(h: self.h, s: self.s, v: self.v)
    }
}

extension HSV: Identifiable {
    var id: Color {
        return swiftUIColor
    }
    
    var swiftUIColor: Color {
        return rgb.swiftUIColor
    }
    
    var complementary: HSV {
        let adjusted = h - ColorCombination.complementary.angles[0]
        return HSV(h: adjusted, s: s, v: v)
    }
    
    var analogous1: HSV {
        let adjusted = h - ColorCombination.analogous.angles[0]
        return HSV(h: adjusted, s: s, v: v)
    }
    
    var analogous2: HSV {
        let adjusted = h - ColorCombination.analogous.angles[1]
        return HSV(h: adjusted, s: s, v: v)
    }
    
    var triadic1: HSV {
        let adjusted = h - ColorCombination.triadic.angles[0]
        return HSV(h: adjusted, s: s, v: v)
    }
    
    var triadic2: HSV {
        let adjusted = h - ColorCombination.triadic.angles[1]
        return HSV(h: adjusted, s: s, v: v)
    }
    
    var tetradic1: HSV {
        let adjusted = h - ColorCombination.tetradic.angles[0]
        return HSV(h: adjusted, s: s, v: v)
    }
    
    var tetradic2: HSV {
        let adjusted = h - ColorCombination.tetradic.angles[1]
        return HSV(h: adjusted, s: s, v: v)
    }
    
    var tetradic3: HSV {
        let adjusted = h - ColorCombination.tetradic.angles[2]
        return HSV(h: adjusted, s: s, v: v)
    }
}

// MARK: For use with `ColorCombination` enum
extension HSV {
    func additionalCombinationColors(for combination: ColorCombination) -> [HSV] {
        switch combination {
        case .complementary:
            return [complementary]
        case .analogous:
            return [analogous1, analogous2]
        case .triadic:
            return [triadic1, triadic2]
        case .tetradic:
            return [tetradic1, tetradic2, tetradic3]
        default:
            return []
        }
    }
    
    func allCombinationColors(for combination: ColorCombination) -> [HSV] {
        switch combination {
        case .single:
            return [self]
        case .complementary:
            return [self, complementary]
        case .analogous:
            return [self, analogous1, analogous2]
        case .triadic:
            return [self, triadic1, triadic2]
        case .tetradic:
            return [self, tetradic1, tetradic2, tetradic3]
        }
    }
}
