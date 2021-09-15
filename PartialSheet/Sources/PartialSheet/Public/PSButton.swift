//
//  SwiftUIView.swift
//  
//
//  Created by Andrea Miotto on 28/02/22.
//

import SwiftUI

/**
 The PSButton it's helps to avoid the rage tapping on the button that could cause inconsistents in the UI.
It simply toggle the enabled status of the button for few time. You can reproduce the same behavior in any of your custom buttons.
 ```
 buttonDisabled.toggle()
 DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
     buttonDisabled.toggle()
 }
 ```
 Always rememebr to call also `View.attachPartialSheetToRoot()` and `View.partialSheet()` to display correctly the **PartialSheet**.
*/
public struct PSButton<Content: View>: View {
    @Binding var isPresenting: Bool
    var label: () -> Content
    var acion: (() -> Void)?
    @State private var buttonDisabled: Bool = false

    public init(
        isPresenting: Binding<Bool>,
        action: (() -> Void)? = nil,
        label: @escaping () -> Content) {
            self._isPresenting = isPresenting
            self.label = label
        }

    public var body: some View {
        Button {
            toggleButton()
            isPresenting.toggle()
        } label: {
            label()
        }
        .disabled(buttonDisabled)
    }

    private func toggleButton() {
        buttonDisabled.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            buttonDisabled.toggle()
        }
    }
}

struct PSButton_Previews: PreviewProvider {
    static var previews: some View {
        PSButton(isPresenting: .constant(true)) {
            Text("Mostra Partial Sheet")
        }
    }
}
