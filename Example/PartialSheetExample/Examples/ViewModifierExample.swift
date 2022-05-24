//
//  ViewModifierExample.swift
//  PartialSheetExample
//
//  Created by woko on 03/09/2020.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct ViewModifierExample: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager

    @State var isSheetShown = false
    @State var viewContent = "Initial content"
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.isSheetShown = true
            }, label: {
                Text("Display the ViewModifier sheet")
            })
            .padding()
            Spacer()
        }
        .navigationBarTitle("ViewModifier Example")
        .navigationViewStyle(StackNavigationViewStyle())
        .partialSheet(isPresented: $isSheetShown) {
            ViewModifierView(content: self.$viewContent)
                .padding(.vertical, 50)
        }
        .onAppear {
            partialSheetManager.isDraggable = false
        }
        .onDisappear {
            partialSheetManager.isDraggable = true
        }
    }
}

struct ViewModifierExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ViewModifierExample()
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

struct ViewModifierView: View {
    @Binding var content: String
    
    var body: some View {
        VStack {
            Text(content)
            Button(action: {
                self.content = "Inner content"
            }, label: {
                Text("Change content")
            })
        }
    }
}
