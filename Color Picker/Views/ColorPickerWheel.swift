//
//  ColorPickerWheel.swift
//  Color Picker
//
//  Created by David Rozmajzl on 9/26/23.
//

import SwiftUI

struct ColorPickerWheel<Overlay: View>: View {
    private let radius: CGFloat
    private let type: ColorCombination
    @Binding var selection: RGB
    @Binding var brightness: CGFloat
    private let indicatorStrokeColor: Color
    private let overlay: () -> Overlay
    
    init(
        _ selection: Binding<RGB>,
        type: ColorCombination = .single,
        radius: CGFloat,
        brightness: Binding<CGFloat> = .constant(1),
        stroke indicatorStrokeColor: Color = .white,
        @ViewBuilder overlay: @escaping () -> Overlay
    ) {
        _selection = selection
        self.type = type
        self.radius = radius
        _brightness = brightness
        self.indicatorStrokeColor = indicatorStrokeColor
        self.overlay = overlay
    }
    
    private var iconDiameter: CGFloat {
        return max(20, radius / 9)
    }
    
    private var secondaryIconDiameter: CGFloat {
        return max(15, iconDiameter / 2)
    }
    
    private var strokeWidth: CGFloat {
        return CGFloat(Int(iconDiameter / 10))
    }
    
    private var indicatorStrokeWidth: CGFloat {
        return CGFloat(Int(secondaryIconDiameter / 6))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: Color wheel + some styling
                Group {
                    CIHueSaturationValueGradientView(radius: radius, brightness: $brightness)
                        .frame(width: radius, height: radius)
                        .blur(radius: 10, opaque: true)
                        .clipShape(
                            Circle()
                                .size(width: radius, height: radius)
                        )
                        .overlay(overlay())
                    
                    RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.8 * Double(brightness)), .clear]), center: .center, startRadius: 0, endRadius: (radius / 2) - iconDiameter)
                        .blendMode(.screen)
                }
                
                // MARK: Main indicator (always present)
                Circle()
                    .fill(selection.swiftUIColor)
                    .stroke(indicatorStrokeColor, lineWidth: strokeWidth)
                    .frame(width: iconDiameter, height: iconDiameter)
                    .offset(x: ((radius / 2) - (strokeWidth * 2)) * selection.hsv.s)
                    .rotationEffect(.degrees(-Double(selection.hsv.h)))
                
                // MARK: Additional optional color selection indicators
                Group {
                    let angles = type.angles
                    let secondaryColors = selection.additionalCombinationColors(for: type)
                    ForEach(0..<secondaryColors.count, id: \.self) { index in
                        Circle()
                            .fill(secondaryColors[index].swiftUIColor)
                            .stroke(indicatorStrokeColor, lineWidth: indicatorStrokeWidth)
                            .frame(width: secondaryIconDiameter, height: secondaryIconDiameter)
                            .offset(x: ((radius / 2) - (strokeWidth * 2)) * selection.hsv.s)
                            .rotationEffect(.degrees(-Double(selection.hsv.h) + angles[index]))
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        // Work out angle which will be the hue.
                        let y = geometry.frame(in: .global).midY - value.location.y
                        let x = value.location.x - geometry.frame(in: .global).midX
                        
                        // Use `atan2` to get the angle from the center point then convert
                        // than into a 360 value with custom function(find it in helpers).
                        let hue = atan2To360(atan2(y, x))
                        
                        // Work out distance from the center point which will be the saturation.
                        let center = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
                        
                        // Maximum value of sat is 1 so we find the smallest of 1 and the distance.
                        let saturation = min(distance(center, value.location) / (radius / 2), 1)
                        
                        // Convert HSV to RGB and set the color which will notify the views.
                        selection = HSV(h: hue, s: saturation, v: brightness).rgb
                    }
            )
            .onChange(of: brightness) { _, newBrightness in
                selection = HSV.toRGB(h: selection.hsv.h, s: selection.hsv.s, v: newBrightness)
            }
        }
        .frame(width: radius, height: radius)
    }
}
