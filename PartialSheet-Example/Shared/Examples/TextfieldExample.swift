//
//  TextfieldExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct TextfieldExample: View {
    @State private var isSheetPresented = false

    var body: some View {
        HStack {
            Spacer()
            PSButton(
                isPresenting: $isSheetPresented,
                label: {
                    Text("Display the Partial Shehet")
            })
                .padding()
            Spacer()
        }
        .partialSheet(isPresented: $isSheetPresented, content: {
            SheetTextFieldView()
        })
        .navigationBarTitle("TextField Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TextfieldExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextfieldExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SheetTextFieldView: View {
    @State private var longer: Bool = false
    @State private var text: String = ""

    var body: some View {
            VStack {
                VStack(alignment: .center, spacing: 10) {
                    Text("Settings Panel")
                        .font(.headline)
                    TextField("Name & Surname", text: self.$text)
                        .textFieldStyle(.roundedBorder)
                    Toggle(isOn: self.$longer) {
                        Text("Advanced")
                    }
                }
                .padding()
                if self.longer {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("More info...")
                            .font(.body)
                        TextField("Address", text: .constant("Address"))
                            .textFieldStyle(.roundedBorder)
                        Spacer()
                    }
                    .padding()
                }
        }
        .frame(height: self.longer ? 250 : 150)
    }
}
