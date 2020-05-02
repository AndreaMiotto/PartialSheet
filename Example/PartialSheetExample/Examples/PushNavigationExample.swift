//
//  PushNavigationExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct PushNavigationExample: View {
    @EnvironmentObject var partialSheetManager : PartialSheetManager

    @State var showNextView: Bool = false

    var body: some View {
        ZStack {
            NavigationLink(destination: Text("Destination View"), isActive: $showNextView, label: {EmptyView()})

            Button(action: {
                self.partialSheetManager.showPartialSheet {
                    Button(action: {
                        self.partialSheetManager.isPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                            self.showNextView = true
                        }
                    }) {
                        Text("Navigation Link")
                    }
                }
            }) {
                Text("Show Partial Sheet")
            }
        }
        .navigationBarTitle(Text("Push Navigation"))
    }
}

struct PushNavigationExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PushNavigationExample()
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}
