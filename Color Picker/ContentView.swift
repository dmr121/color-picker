//
//  ContentView.swift
//  Color Picker
//
//  Created by David Rozmajzl on 9/27/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var rgb = RGB(r: 1, g: 1, b: 1)
    @State private var brightness: CGFloat = 1
    @State private var colorCombination = ColorCombination.analogous
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: rgb.allCombinationColors(for: colorCombination).map{$0.swiftUIColor},
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                VStack {
                    ColorPickerWheel(
                        $rgb,
                        type: colorCombination,
                        radius: geometry.size.width * 0.9,
                        brightness: $brightness
                    ) {
                        Circle().stroke(.white, lineWidth: 4)
                    }
                    
                    VStack {
                        HStack {
                            Text("Brightness: \(String(format: "%.2f", brightness))")
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        
                        Slider(value: $brightness, in: 0...1.0)
                            .padding(.bottom)
                        
                        Picker("Color Combination Mode", selection: $colorCombination) {
                            ForEach(ColorCombination.allCases) { combination in
                                Text(combination.label)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.black: .white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
