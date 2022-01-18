//
//  Home.swift
//  CustomBottomSheet
//
//  Created by Sopnil Sohan on 18/1/22.
//

import Foundation
import SwiftUI

struct Home: View {
    
    //Search Text Binding value...
    @State var searchText = ""
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        
        ZStack {
            
            //For Getting Frame For Image...
            GeometryReader { proxy in
                
                let frame = proxy.frame(in: .global)
                
                Image("bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.width, height: frame.height)
            }
            .blur(radius: getBlurRadius())
            .ignoresSafeArea()
            
            //Bottom Sheet...
            
            //For Getting Height For Drag Gesture...
            GeometryReader { proxy -> AnyView in
                
                let height = proxy.frame(in: .global).height
                
                return AnyView (
                    ZStack {
                        BlurView(style: .systemThinMaterialDark)
                            .clipShape(CustomCorner(corners: [.topRight,.topLeft], radius: 30))
                        
                        VStack {
                            
                            VStack {
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 4)
                                    .padding(.top)
                                
                                TextField("Search", text: $searchText)
                                    .padding(.vertical,10)
                                    .padding(.horizontal)
                                    .background(BlurView(style: .dark))
                                    .cornerRadius(10)
                                    .colorScheme(.dark)
                                    .padding(.top,10)
                            }
                            .frame(height: 140)
                            
                            //ScrollView Content...
                            ScrollView(.vertical, showsIndicators: false, content: {
                                BottomContent()
                            })
                            
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                        .offset(y: height - 140)
                        .offset(y: -offset > 0 ? -offset <= (height - 140) ? offset : -(height - 140) : 0)
                        .gesture(DragGesture().updating($gestureOffset, body: {value, out, _ in
                            out = value.translation.height
                            onChange()
                        }).onEnded({ value in
                            
                            let maxHeight = height - 140
                            
                            withAnimation {
                                //Logic Condition For Moving States...
                                //Up down or mid...
                                if -offset > 140 && -offset < maxHeight / 2 {
                                    //Mid..
                                    offset = -(maxHeight / 3)
                                }
                                else if -offset > maxHeight / 2 {
                                    offset = -maxHeight
                                }
                                else {
                                    offset = 0
                                }
                            }
                            // Storing Last Offset...
                            // So that the gesture can continue from the last position...
                            lastOffset = offset
                            
                        }))
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
    }
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    func getBlurRadius()->CGFloat {
        let progress = -offset / (UIScreen.main.bounds.height - 140)
        
        return progress * 30
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
