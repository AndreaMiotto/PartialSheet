//
//  TextfieldExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI


struct TextfieldExample: View {
    @EnvironmentObject var partialSheetManager : PartialSheetManager
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                    print("text sheet dismissed")
                }) {
                     SheetTextFieldView()
                }
            }, label: {
                Text("Display the Partial Shehet")
            })
                .padding()
            Spacer()
        }
        .navigationBarTitle("Textfield Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TextfieldExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextfieldExample()
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

struct SheetTextFieldView: View {
    @State private var longer: Bool = false
    @State private var text: String = "some text"
    
    
    var body: some View {
        VStack {
            Group {
                Text("Settings Panel")
                    .font(.headline)
                
                TextField("TextField", text: self.$text)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(UIColor.systemGray2), lineWidth: 1)
                )
                
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

