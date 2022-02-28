//
//  DatePickerExample.swift
//  PartialSheetExample
//
//  Created by Rasmus Styrk on 14/08/2020.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI
import PartialSheet

struct DatePickerExample: View {
    @State private var isSheetPresented = false

    var body: some View {
        HStack {
            Spacer()
            PSButton(
                isPresenting: $isSheetPresented,
                label: {
                    Text("Display DatePicker example Sheet")
            })
            .padding()
            Spacer()
        }
        .partialSheet(isPresented: $isSheetPresented,
                      content: DatePickerSheetView.init)
        .navigationBarTitle("Date Picker Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DatePickerExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatePickerExample()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DatePickerSheetView: View {
    @State private var date: Date = Date()

    var body: some View {
        VStack {
            VStack {
                Text("Settings Panel").font(.headline)
                DatePicker("Date", selection: $date)
            }
            .padding()
            .frame(height: 270)
        }
    }
}
