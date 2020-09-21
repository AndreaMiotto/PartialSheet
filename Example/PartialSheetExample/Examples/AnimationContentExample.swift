//
//  AnimationContentExample.swift
//  PartialSheetExample
//
//  Created by Eliott Robson on 21/09/2020.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct AnimationContentExample: View {
  @EnvironmentObject var partialSheet: PartialSheetManager

  var body: some View {
    VStack {
      Button(
        action: {
          self.partialSheet.showPartialSheet {
            AnimationSheetView()
          }
        },
        label: {
          Text("Show Partial Sheet")
        }
      )
    }
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
                DispatchQueue.main.async {
                  withAnimation {
                    explicitScale = CGFloat.random(in: 0.5..<1.5)
                  }
                }
            }
            
            Text("Tap to animate implicitly")
              .padding()
              .background(Color.orange)
              .cornerRadius(5)
              .scaleEffect(implicitScale)
              .animation(.default)
              .onTapGesture {
                  DispatchQueue.main.async {
                    implicitScale = CGFloat.random(in: 0.5..<1.5)
                  }
              }
            
            Text("Tap to change with no animation")
              .padding()
              .background(Color.red)
              .cornerRadius(5)
              .scaleEffect(noScale)
              .onTapGesture {
                  DispatchQueue.main.async {
                    noScale = CGFloat.random(in: 0.5..<1.5)
                  }
              }
        }
      }
}

struct AnimationContentExample_Previews: PreviewProvider {
    static var previews: some View {
        AnimationContentExample()
            .environmentObject(PartialSheetManager())
    }
}
