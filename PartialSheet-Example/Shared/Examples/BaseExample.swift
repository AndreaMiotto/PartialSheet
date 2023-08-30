//
//  NormalExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct BasicExample: View {
    @State private var isSheetPresented = false

    var body: some View {
        HStack {
            Spacer()
            PSButton(
                isPresenting: $isSheetPresented,
                label: {
                    Text("Display the Partial Sheet")
                })
                .padding()
            Spacer()
        }
        .partialSheet(
            isPresented: $isSheetPresented,
            onDismiss: {
                print("On Dismiss Called")
            },
            content: SheetView.init
        )
        .navigationBarTitle("Basic Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BasicExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BasicExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SheetView: View {
    @State private var longer: Bool = false
    @State private var text: String = "some text"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                HStack {
                    Spacer()
                Text("Settings Panel")
                    .font(.headline)
                    Spacer()
                }

                Text("Vestibulum iaculis sagittis sem, vel hendrerit ex. ")
                    .font(.body)
                    .lineLimit(2)

                Toggle(isOn: self.$longer) {
                    Text("Advanced")
                }
            }
            .padding(0)
            .frame(height: 50)
            if self.longer {
                VStack {
                    Divider()
                    Spacer()
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vestibulum porttitor ligula quis faucibus. Maecenas auctor tincidunt maximus. Donec lectus dui, fermentum sed orci gravida, porttitor porta dui. ")
                    Spacer()
                }
                .frame(height: 200)
            }
        }
        .padding(.horizontal, 10)
    }
}
