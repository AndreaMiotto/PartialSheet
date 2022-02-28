//
//  HandleBarFreeExample.swift
//  PartialSheetExample
//
//  Created by Gijs van Veen on 12/05/2021.
//  Copyright © 2021 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct HandleBarFreeExample: View {
    @State private var isSheetPresented = false
    let iPhoneStyle = PSIphoneStyle(
        background: .solid(Color(uiColor: .systemBackground)),
        handleBarStyle: .none,
        cover: .enabled(Color.black.opacity(0.4)),
        cornerRadius: 10
    )

    var body: some View {
        VStack {
            Spacer()
            PSButton(
                isPresenting: $isSheetPresented,
                label: {
                    Text("Display the HandleBarFreeExample Sheet")
                })
                .padding()
            Spacer()
        }
        .partialSheet(
            isPresented: $isSheetPresented,
            iPhoneStyle: iPhoneStyle,
            content: {
                HandleBarFreeSheetView()
            })
        .navigationBarTitle("HandleBar Free")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HandleBarFreeExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HandleBarFreeExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HandleBarFreeSheetView: View {
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
