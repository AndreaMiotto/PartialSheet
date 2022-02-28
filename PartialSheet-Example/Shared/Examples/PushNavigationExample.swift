//
//  PushNavigationExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct PushNavigationExample: View {
    @State private var isSheetPresented = false
    @State var showNextView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: Text("Destination View"), isActive: $showNextView, label: {EmptyView()})
            PSButton(
                isPresenting: $isSheetPresented,
                label: {
                    Text("Show Partial Sheet")
                })
        }
        .partialSheet(isPresented: $isSheetPresented, content: {
            Button(action: {
                isSheetPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                    self.showNextView = true
                }
            }, label: {
                Text("Navigation Link")
            })
                .padding()
        })
        .navigationBarTitle(Text("Push Navigation"))
    }
}

struct PushNavigationExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PushNavigationExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
