//
//  ContentView.swift
//  Shared
//
//  Created by Andrea Miotto on 26/02/22.
//

import SwiftUI
import PartialSheet

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    Section {
                        Text("""
                    Partial Sheet modifier will display a totally custom sheet with an height based on its content.\n
                    In this way the sheet will cover the screen only for the space it will need.\n
                    On iPad and Mac devices it will present a normal .sheet view.
                    """)
                            .font(.footnote)
                            .padding()
                    }
                    Section("Examples") {
                        NavigationLink(
                            destination: BasicExample(),
                            label: {Text("Basic Example")
                            })
                        NavigationLink(
                            destination: TextfieldExample(),
                            label: {Text("TextField Example")
                            })
                        NavigationLink(
                            destination: ListExample(),
                            label: {Text("List Example")
                            })
                        NavigationLink(
                            destination: ScrollViewExample(),
                            label: {Text("ScrollView Example")
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
                            destination: GradientExample(),
                            label: {Text("Gradient Example")
                            })
                        NavigationLink(
                            destination: AnimationContentExample(),
                            label: {Text("AnimationContent Example")
                            })
                        Group {
                        NavigationLink(
                            destination: HandleBarFreeExample(),
                            label: {Text("HandleBarFree Example")
                            })
                        NavigationLink(
                            destination: CustonSlideAnimationExample(),
                            label: {Text("Custom Slide Example")
                            })
                        }
                    }
                }
            }
            .navigationBarTitle("Partial Sheet")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .attachPartialSheetToRoot()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
