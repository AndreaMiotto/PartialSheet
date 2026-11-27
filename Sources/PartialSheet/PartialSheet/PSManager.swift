import SwiftUI

@MainActor
final class PSManager: ObservableObject {
    @Published var isPresented = false {
        didSet {
            guard oldValue, !isPresented else { return }
            let completion = onDismiss
            onDismiss = nil
            owner = nil
            completion?()
        }
    }
    // Keep content alive during dismissal, including custom animation durations.
    // The next presentation replaces it; no delayed cleanup can erase a new sheet.
    @Published private(set) var content = AnyView(EmptyView())
    private(set) var owner: UUID?
    var type: PSType = .dynamic
    var iPhoneStyle: PSIphoneStyle = .defaultStyle()
    var iPadMacStyle: PSIpadMacStyle = .defaultStyle()
    private var onDismiss: (() -> Void)?
    var slideAnimation = PSSlideAnimation()

    func updatePartialSheet<T: View>(owner: UUID,
                                    isPresented: Bool,
                                    type: PSType,
                                    iPhoneStyle: PSIphoneStyle,
                                    iPadMacStyle: PSIpadMacStyle,
                                    slideAnimation: PSSlideAnimation?,
                                    content: () -> T,
                                    onDismiss: @escaping () -> Void) {
        if !isPresented {
            guard self.owner == owner else { return }
            dismiss()
            return
        }
        if self.isPresented, self.owner != owner { dismiss() }
        self.owner = owner
        self.type = type
        self.iPhoneStyle = iPhoneStyle
        self.iPadMacStyle = iPadMacStyle
        self.slideAnimation = slideAnimation ?? PSSlideAnimation()
        self.onDismiss = onDismiss
        self.content = AnyView(content())
        withAnimation(self.slideAnimation.slideIn) { self.isPresented = true }
    }

    func dismiss() {
        withAnimation(slideAnimation.slideOut) { isPresented = false }
    }
}
