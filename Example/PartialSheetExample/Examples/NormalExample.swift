//
//  NormalExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct NormalExample: View {

    @EnvironmentObject var partialSheetManager : PartialSheetManager
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                     print("normal sheet dismissed")
                }) {
                     SheetView()
                }
            }, label: {
                Text("Display the Partial Sheet")
            })
                .padding()
            Spacer()
        }
        .navigationBarTitle("Normal Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NormalExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NormalExample()
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

struct SheetView: View {

    var body: some View {
        VStack {
            Group {
                Text("Settings Panel").font(.headline)
                Text("This is a partial sheet - Hello World").font(.subheadline)
            }
            .padding()
            .frame(height: 50)
        }
    }
}
