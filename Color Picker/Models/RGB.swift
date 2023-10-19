//
//  RGB.swift
//  Color Picker
//
//  Created by David Rozmajzl on 10/19/23.
//

import SwiftUI

/// This was all taken from here and only slightly edited. -> https://gist.github.com/FredrikSjoberg/cdea97af68c6bdb0a89e3aba57a966ce

/// Struct that holds red, green and blue values. Also has a `hsv` value that converts it's values to hsv.
struct RGB {
    private(set) var r: CGFloat // Percent [0,1]
    private(set) var g: CGFloat // Percent [0,1]
    private(set) var b: CGFloat // Percent [0,1]
    
    static func toHSV(r: CGFloat, g: CGFloat, b: CGFloat) -> HSV {
        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
        
        let v = max
        let delta = max - min
        
        guard delta > 0.00001 else { return HSV(h: 0, s: 0, v: max) }
        guard max > 0 else { return HSV(h: -1, s: 0, v: v) } // Undefined, achromatic grey
        let s = delta / max
        
        let hue: (CGFloat, CGFloat) -> CGFloat = { max, delta -> CGFloat in
            if r == max { return (g-b)/delta } // between yellow & magenta
            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
            else { return 4 + (r-g)/delta } // between magenta & cyan
        }
        
        let h = hue(max, delta) * 60 // In degrees
        
        return HSV(h: (h < 0 ? h+360 : h) , s: s, v: v)
    }
    
    var hsv: HSV {
        return RGB.toHSV(r: self.r, g: self.g, b: self.b)
    }
}

extension RGB: Identifiable {
    var id: Color {
        return swiftUIColor
    }
    
    var swiftUIColor: Color {
        return Color.init(red: Double(r), green: Double(g), blue: Double(b))
    }
    
    var complementary: RGB {
        let adjusted = hsv.h - ColorCombination.complementary.angles[0]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
    
    var analogous1: RGB {
        let adjusted = hsv.h - ColorCombination.analogous.angles[0]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
    
    var analogous2: RGB {
        let adjusted = hsv.h - ColorCombination.analogous.angles[1]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
    
    var triadic1: RGB {
        let adjusted = hsv.h - ColorCombination.triadic.angles[0]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
    
    var triadic2: RGB {
        let adjusted = hsv.h - ColorCombination.triadic.angles[1]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
    
    var tetradic1: RGB {
        let adjusted = hsv.h - ColorCombination.tetradic.angles[0]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
    
    var tetradic2: RGB {
        let adjusted = hsv.h - ColorCombination.tetradic.angles[1]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
    
    var tetradic3: RGB {
        let adjusted = hsv.h - ColorCombination.tetradic.angles[2]
        return HSV.toRGB(h: adjusted, s: hsv.s, v: hsv.v)
    }
}

// MARK: For use with `ColorCombination` enum
extension RGB {
    func additionalCombinationColors(for combination: ColorCombination) -> [RGB] {
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
    
    func allCombinationColors(for combination: ColorCombination) -> [RGB] {
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
