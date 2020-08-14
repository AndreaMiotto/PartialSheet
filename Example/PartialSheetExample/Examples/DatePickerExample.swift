//
//  DatePickerExample.swift
//  PartialSheetExample
//
//  Created by Rasmus Styrk on 14/08/2020.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

struct DatePickerExample: View {
    
    @EnvironmentObject var partialSheetManager : PartialSheetManager
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                    print("DatePickerExample sheet dismissed")
                }) {
                    DatePickerSheetView()
                }
            }, label: {
                Text("Display the DatePickerExample Sheet")
            })
            .padding()
            Spacer()
        }
        .navigationBarTitle("DatePickerExample Example")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DatePickerExample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatePickerSheetView()
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

struct DatePickerSheetView: View {
    @State private var date: Date = Date()
    
    var body: some View {
        VStack {
            Group {
                Text("Settings Panel").font(.headline)
                DatePicker("Select date", selection: $date)
            }
            .padding()
            .frame(height: 50)
        }
    }
}
