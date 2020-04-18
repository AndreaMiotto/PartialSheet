//
//  ContentView.swift
//  PartialSheetExample
//
//  Created by Bobby Schultz on 1/29/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var modalPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                Text("""
                Hi, this is the Partial Sheet modifier.

                On iPhone devices it allows you to dispaly a totally custom sheet with a relative height based on his content.
                In this way the sheet will cover the screen only for the space it will need.

                On iPad and Mac devices it will present a normal .sheet view.
                """)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.modalPresented = true
                    }, label: {
                        Text("Display the Partial Shehet")
                    })
                        .padding()
                    Spacer()
                }
                Spacer()
                Spacer()
            }
            .padding()
            .navigationBarTitle("Partial Sheet")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .partialSheet(presented: $modalPresented) {
            SheetView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SheetView: View {
    @State private var longer: Bool = false
    @State private var text: String = "some text"


    var body: some View {
        VStack {
            Group {
                Text("Settings Panel")
                    .font(.headline)

                TextField("TextField", text: self.$text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Toggle(isOn: self.$longer) {
                    Text("Advanced")
                }

            }
            .padding()
            .frame(height: 50)
            if self.longer {
                VStack {
                    Text("More settings here...")
                }
                .frame(height: 200)
            }
        }
    }
}
