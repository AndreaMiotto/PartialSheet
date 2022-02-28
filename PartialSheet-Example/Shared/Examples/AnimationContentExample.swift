//
//  AnimationContentExample.swift
//  PartialSheetExample
//
//  Created by Eliott Robson on 21/09/2020.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct AnimationContentExample: View {
    @State private var isSheetPresented = false

    var body: some View {
        VStack {
            Button(
                action: {
                    isSheetPresented = true
                },
                label: {
                    Text("Show Partial Sheet")
                }
            )
        }
        .partialSheet(isPresented: $isSheetPresented, content: AnimationSheetView.init)
    }
}

struct AnimationSheetView: View {
    @State private var explicitScale: CGFloat = 1
    @State private var implicitScale: CGFloat = 1
    @State private var noScale: CGFloat = 1

    var body: some View {
        VStack {
            Text("Tap to animate explicitly")
                .padding()
                .background(Color.green)
                .cornerRadius(5)
                .scaleEffect(explicitScale)
                .onTapGesture {
                    withAnimation {
                        explicitScale = CGFloat.random(in: 0.5..<1.5)
                    }
                }

            Text("Tap to animate implicitly")
                .padding()
                .background(Color.orange)
                .cornerRadius(5)
                .scaleEffect(implicitScale)
                .animation(.default, value: implicitScale)
                .onTapGesture {
                    implicitScale = CGFloat.random(in: 0.5..<1.5)
                }

            Text("Tap to change with no animation")
                .padding()
                .background(Color.red)
                .cornerRadius(5)
                .scaleEffect(noScale)
                .onTapGesture {
                    noScale = CGFloat.random(in: 0.5..<1.5)
                }
        }
        .padding()
    }
}

struct AnimationContentExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AnimationContentExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
