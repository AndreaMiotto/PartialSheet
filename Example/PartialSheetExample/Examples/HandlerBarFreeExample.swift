//
//  HandlerBarFreeExample.swift
//  PartialSheetExample
//
//  Created by Gijs van Veen on 12/05/2021.
//  Copyright © 2021 Swift. All rights reserved.
//

import SwiftUI

struct HandlerBarFreeExample: View {
    
    // Adding a new sheet manager and style locally - *this is not recommended (it's just for the example sake)*
    // - recommended way is adding one global sheet as per the documentation.
    let sheetManager: PartialSheetManager = PartialSheetManager()
    let sheetStyle = PartialSheetStyle(background: .solid(Color(UIColor.tertiarySystemBackground)),
                                       handlerBarStyle: .none,
                                       iPadCloseButtonColor: Color(UIColor.systemGray2),
                                       enableCover: true,
                                       coverColor: Color.black.opacity(0.4),
                                       blurEffectStyle: nil,
                                       cornerRadius: 10,
                                       minTopDistance: 110
    )
        
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.sheetManager.showPartialSheet({
                    print("HandlerBarFreeExample sheet dismissed")
                }) {
                    HandlerBarFreeSheetView()
                }
            }, label: {
                Text("Display the HandlerBarFreeExample Sheet")
            })
            .padding()
            Spacer()
        }
        .navigationBarTitle("HandlerBarFreeExample Example")
        .navigationViewStyle(StackNavigationViewStyle())
        .addPartialSheet(style: self.sheetStyle)
        .environmentObject(self.sheetManager)
    }
}

struct HandlerBarFreeExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HandlerBarFreeSheetView()
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

struct HandlerBarFreeSheetView: View {
    @State private var longer: Bool = false
    @State private var text: String = "some text"
    
    @EnvironmentObject var partialSheetManager : PartialSheetManager

    
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
                
                Button("Close Button") {
                    self.partialSheetManager.closePartialSheet()
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
