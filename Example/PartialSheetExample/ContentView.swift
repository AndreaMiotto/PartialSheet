//
//  ContentView.swift
//  PartialSheetExample
//
//  Created by Bobby Schultz on 1/29/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var editing:Bool = true
    @State private var text:String = "some text"
    var body: some View {
        VStack(alignment: .center) {
            Button(action: { self.editing.toggle() } ) {
                Text("Hello, World!")
            }
            Spacer()
        }
        .padding()
        .partialSheet(
            presented: self.$editing,
            backgroundColor: Color.white,
            handlerBarColor: Color.gray,
            enableCover: true,
            coverColor: Color.black.opacity(0.6)) {
                VStack(alignment: .center) {
                    TextField("input", text: self.$text)
                }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
