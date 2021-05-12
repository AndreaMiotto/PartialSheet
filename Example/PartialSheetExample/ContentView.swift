//
//  ContentView.swift
//  PartialSheetExample
//
//  Created by Bobby Schultz on 1/29/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                Text("""
                Hi, this is the Partial Sheet modifier.

                On iPhone devices it allows you to display a totally custom sheet with a relative height based on its content.
                In this way the sheet will cover the screen only for the space it will need.

                On iPad and Mac devices it will present a normal .sheet view.
                """)
                    .padding()
                Spacer()

                Text("Examples").font(.headline)
                    .padding()

                List {
                    NavigationLink(
                        destination: NormalExample(),
                        label: {Text("Normal Example")
                    })
                    NavigationLink(
                        destination: TextfieldExample(),
                        label: {Text("Textfield Example")
                    })
                    NavigationLink(
                        destination: ListExample(),
                        label: {Text("List Example")
                    })
                    NavigationLink(
                        destination: PushNavigationExample(),
                        label: {Text("Push Navigation Example")
                    })
                    NavigationLink(
                        destination: DatePickerExample(),
                        label: {Text("DatePicker Example")
                    })
                    NavigationLink(
                        destination: PickerExample(),
                        label: {Text("Picker Example")
                    })
                    NavigationLink(
                        destination: BlurredExample(),
                        label: {Text("Blurred Example")
                    })
                    NavigationLink(
                        destination: ViewModifierExample(),
                        label: {Text("ViewModifier Example")
                    })
                    NavigationLink(
                        destination: AnimationContentExample(),
                        label: {Text("AnimationContent Example")
                    })
                    NavigationLink(
                        destination: HandlerBarFreeExample(),
                        label: {Text("HandlerBarFree Example")
                    })
                }
                Spacer()
                Spacer()
            }
            .navigationBarTitle("Partial Sheet")
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(PartialSheetManager())
    }
}

