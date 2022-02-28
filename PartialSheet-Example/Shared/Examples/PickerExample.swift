//
//  PickerExample.swift
//  PartialSheetExample
//
//  Created by Rasmus Styrk on 14/08/2020.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct PickerExample: View {
    @State private var isSheetPresented = false

    var body: some View {
        HStack {
            Spacer()
            PSButton(
                isPresenting: $isSheetPresented,
                label: {
                    Text("Display the PickerExample Sheet")
                })
                .padding()
            Spacer()
        }
        .partialSheet(isPresented: $isSheetPresented,
                      content: PickerSheetView.init)
        .navigationBarTitle("Picker Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PickerExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PickerExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PickerSheetView: View {
    var strengths = ["Low", "Medium", "High"]
    @State private var selectedStrength = 0

    var body: some View {
        VStack {
            VStack {
                Text("Settings Panel").font(.headline)
                Spacer()
                Text("Wheel Picker").font(.callout)
                Picker(selection: $selectedStrength, label: EmptyView()) {
                    ForEach(0 ..< strengths.count) {
                        Text(self.strengths[$0])
                            .font(.callout)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
                .clipped(antialiased: true)
                .padding(1)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.clear)
                        .border(Color.gray)
                )
                Spacer()
                Text("Inline Picker").font(.callout)
                Picker(selection: $selectedStrength, label: EmptyView()) {
                    ForEach(0 ..< strengths.count) {
                        Text(self.strengths[$0])
                            .font(.callout)
                    }
                }
                Spacer()
            }
            .padding()
            .frame(height: 350)
        }
    }
}
