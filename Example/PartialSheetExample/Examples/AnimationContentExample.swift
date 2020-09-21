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
            VStack(alignment: .leading, spacing: 0) {
              Row(i: 0, isLoading: false)
              ForEach(0 ..< 3) { i in
                Row(i: i + 1, hasAnimation: i == 0)
              }
            }
          }
        },
        label: {
          Text("Show Partial Sheet")
        }
      )
    }
  }
}

struct Row: View {
  let i: Int
    
  var hasAnimation: Bool = false
    
  @State var isLoading: Bool = true

  var body: some View {
    ZStack {
        if !isLoading {
          ZStack {
            hasAnimation ? Color.red : Color.yellow

            Text("Loaded view")
          }
        }
    }
    .animation(hasAnimation ? .default : nil)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + (1.0 * Double(i))) {
        self.isLoading = false
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
