//
//  CIHueSaturationValueGradientView.swift
//  Sound Board
//
//  Created by David Rozmajzl on 9/26/23.
//

import SwiftUI

/// This UIViewRepresentable uses `CIHueSaturationValueGradient` to draw a circular gradient with the RGB colour space as a CIFilter.
struct CIHueSaturationValueGradientView: UIViewRepresentable {
    /// Radius to draw
    var radius: CGFloat
    
    /// The brightness/value of the wheel.
    @Binding var brightness: CGFloat
    
    /// Image view that will hold the rendered CIHueSaturationValueGradient.
    let imageView = UIImageView()
    
    func makeUIView(context: Context) -> UIImageView {
        /// Render CIHueSaturationValueGradient and set it to the ImageView that will be returned.
        imageView.image = renderFilter()
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        /// When the view updates eg. brightness changes, a new CIHueSaturationValueGradient will be generated.
        uiView.image = renderFilter()
    }
    
    /// Generate the CIHueSaturationValueGradient and output it as a UIImage.
    func renderFilter() -> UIImage {
        let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
            "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
            "inputDither": 0,
            "inputRadius": radius * 0.4,
            "inputSoftness": 0,
            "inputValue": brightness
        ])!
        
        // Output as UIImageView
        let image = UIImage(ciImage: filter.outputImage!)
        return image
    }
}
