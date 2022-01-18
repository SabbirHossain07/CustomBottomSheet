//
//  BlurView.swift
//  CustomBottomSheet
//
//  Created by Sopnil Sohan on 18/1/22.
//

import Foundation
import SwiftUI


struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //Do nothing
    }
}
