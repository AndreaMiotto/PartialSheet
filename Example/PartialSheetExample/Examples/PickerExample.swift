//
//  PickerExample.swift
//  PartialSheetExample
//
//  Created by Rasmus Styrk on 14/08/2020.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct PickerExample: View {
    
    @EnvironmentObject var partialSheetManager : PartialSheetManager
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                    print("PickerExample sheet dismissed")
                }) {
                    PickerSheetView()
                }
            }, label: {
                Text("Display the PickerExample Sheet")
            })
            .padding()
            Spacer()
        }
        .navigationBarTitle("PickerExample Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PickerExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PickerSheetView()
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

struct PickerSheetView: View {
    var strengths = ["Mild", "Medium", "Mature"]
    @State private var selectedStrength = 0

    var body: some View {
        VStack {
            VStack {
                Text("Settings Panel").font(.headline)
                Picker(selection: $selectedStrength, label: EmptyView()) {
                    ForEach(0 ..< strengths.count) {
                        Text(self.strengths[$0])
                    }
                }
            }
            .padding()
            .frame(height: 250)
        }
    }
}
