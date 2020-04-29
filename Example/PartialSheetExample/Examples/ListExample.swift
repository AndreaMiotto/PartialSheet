//
//  ListExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct ListExample: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager

    var body: some View {
        List(0...12, id: \.self) { (index) in
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                    print("dismiss sheet for item \(index)")
                }) {
                     Text("Modify item \(index)")
                }
            }, label: {
                Text("Item: \(index)")
            })
        }
        .navigationBarTitle(Text("List Example"))
    }
}

struct ListExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListExample()
        }
    }
}
