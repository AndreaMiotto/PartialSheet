//
//  ListExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct ListExample: View {
    @State private var isSheetPresented = false
    @State private var selectedIndex: Int = 0

    var body: some View {
        List(0...12, id: \.self) { (index) in
            PSButton(
                isPresenting: $isSheetPresented,
                action: { selectedIndex = index },
                label: {
                    Text("Item: \(index)")
                })
        }
        .partialSheet(isPresented: $isSheetPresented, content: {
            Text("Item: \(selectedIndex)")
                .padding()
        })
        .navigationBarTitle(Text("List Example"))
    }
}

struct ListExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
