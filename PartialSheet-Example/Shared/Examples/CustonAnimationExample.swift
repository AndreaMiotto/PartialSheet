//
//  NormalExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct CustonSlideAnimationExample: View {
    let animationIn: Animation = .interpolatingSpring(stiffness: 200, damping: 6)
    @State private var isSheetPresented = false
    
    var body: some View {
        HStack {
            Spacer()
            PSButton(
                isPresenting: $isSheetPresented,
                label: {
                    Text("Display the Partial Sheet with a custon animation")
                })
                .padding()
            Spacer()
        }
        .partialSheet(isPresented: $isSheetPresented,
                      slideAnimation: .init(slideIn: animationIn),
                      content: SheetView.init)
        .navigationBarTitle("Basic Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CustonSlideAnimationExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BasicExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
