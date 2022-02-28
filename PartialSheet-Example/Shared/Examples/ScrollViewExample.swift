//
//  NormalExample.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct ScrollViewExample: View {
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
        .partialSheet(isPresented: $isSheetPresented,
                      type: .scrollView(height: 300, showsIndicators: false),
                      content: ScrollableSheetView.init)
        .navigationBarTitle("Basic Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ScrollViewExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollViewExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ScrollableSheetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Text("Privacy Policy")
                    .font(.headline)
                Spacer()
            }
            Text("Vestibulum iaculis sagittis sem, vel hendrerit ex. ")
                .font(.body)
                .lineLimit(2)
            Divider()
            Text("""
                 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vestibulum porttitor ligula quis faucibus. Maecenas auctor tincidunt maximus. Donec lectus dui, fermentum sed orci gravida, porttitor porta dui.
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vestibulum porttitor ligula quis faucibus. Maecenas auctor tincidunt maximus. Donec lectus dui, fermentum sed orci gravida, porttitor porta dui.
                 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vestibulum porttitor ligula quis faucibus. Maecenas auctor tincidunt maximus. Donec lectus dui, fermentum sed orci gravida, porttitor porta dui.
""")
            Spacer()
                .frame(height: 50)
        }
        .padding(.horizontal, 10)
    }
}
