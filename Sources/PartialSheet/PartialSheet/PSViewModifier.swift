import SwiftUI

@MainActor
struct PartialSheet: ViewModifier {
    @EnvironmentObject var manager: PSManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @GestureState private var dragOffset: CGFloat = 0

    private var handleHeight: CGFloat {
        if case .solid = manager.iPhoneStyle.handleBarStyle { return 40 }
        return 0
    }

    func body(content: Content) -> some View {
        if deviceType == .iphone {
            content
                .accessibilityHidden(manager.isPresented && hasCover)
                .overlay {
                    // Uses this presenter's bounds and SwiftUI keyboard avoidance.
                    // No global screen, key window, or keyboard notifications.
                    GeometryReader { geometry in
                        ZStack(alignment: .bottom) {
                            if manager.isPresented {
                                cover
                                sheet(availableHeight: geometry.size.height)
                                    .background {
                                        background
                                            .clipShape(RoundedRectangle(cornerRadius: manager.iPhoneStyle.cornerRadius))
                                            .ignoresSafeArea(.container, edges: .bottom)
                                    }
                                    .shadow(color: .black.opacity(0.13), radius: 10)
                                    .offset(y: max(0, dragOffset))
                                    .transition(reduceMotion ? .opacity : .move(edge: .bottom))
                                    .accessibilityAddTraits(.isModal)
                                    .accessibilityAction(.escape) { manager.dismiss() }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
        } else {
            content.sheet(isPresented: $manager.isPresented) {
                VStack(alignment: .leading, spacing: 0) {
                    if case let .icon(image, color) = manager.iPadMacStyle.closeButtonStyle {
                        HStack {
                            Spacer()
                            Button { manager.dismiss() } label: { image.foregroundColor(color) }
                                .accessibilityLabel(Text("Close"))
                        }.padding()
                    }
                    manager.content
                    Spacer(minLength: 0)
                }
                .background(manager.iPadMacStyle.backgroundColor)
            }
        }
    }

    private var hasCover: Bool {
        if case .enabled = manager.iPhoneStyle.cover { return true }
        return false
    }

    @ViewBuilder private var cover: some View {
        if case .enabled(let color) = manager.iPhoneStyle.cover {
            color
                .contentShape(Rectangle())
                .ignoresSafeArea(.container)
                .onTapGesture { manager.dismiss() }
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder private var background: some View {
        switch manager.iPhoneStyle.background {
        case .solid(let color): color
        case .blur(let material): Rectangle().fill(material)
        case .gradient(let gradient): gradient
        }
    }

    private func sheet(availableHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            if case .solid(let color) = manager.iPhoneStyle.handleBarStyle {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(color)
                    .frame(width: 40, height: 5)
                    .frame(maxWidth: .infinity)
                    .frame(height: handleHeight)
                    .contentShape(Rectangle())
                    .gesture(dragGesture)
                    .accessibilityHidden(true)
            }
            switch manager.type {
            case .dynamic:
                manager.content
                    .frame(maxWidth: .infinity)
                    .gesture(dragGesture)
            case let .scrollView(height, showsIndicators):
                PSScrollVIew(showsIndicators: showsIndicators, offsetChanged: {
                    if $0.y > 60 { manager.dismiss() }
                }) { manager.content }
                .frame(height: max(0, min(height, availableHeight - handleHeight)))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: max(0, availableHeight), alignment: .top)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($dragOffset) { value, state, _ in
                state = max(0, value.translation.height)
            }
            .onEnded { value in
                if value.translation.height > 60 || value.predictedEndTranslation.height > 120 {
                    manager.dismiss()
                }
            }
    }
}
