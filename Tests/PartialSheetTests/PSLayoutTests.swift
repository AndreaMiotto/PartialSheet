import XCTest
import SwiftUI
@testable import PartialSheet

final class PSLayoutTests: XCTestCase {
    @MainActor
    func testInitiallyPresentedSheetUsesContainerWidthAndContentHeight() async {
        let appeared = expectation(description: "Initially true binding presents content")
        var measured = CGRect.zero
        let root = Color.clear
            .frame(width: 280, height: 450)
            .partialSheet(isPresented: .constant(true)) {
                Text("Content")
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .background(GeometryReader { proxy in
                        Color.clear.onAppear {
                            measured = proxy.frame(in: .global)
                            appeared.fulfill()
                        }
                    })
            }
            .attachPartialSheetToRoot()
        let controller = UIHostingController(rootView: root)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.view.layoutIfNeeded()
        await fulfillment(of: [appeared], timeout: 5)
        XCTAssertEqual(measured.width, 280, accuracy: 1)
        XCTAssertEqual(measured.height, 80, accuracy: 1)
        window.isHidden = true
        window.rootViewController = nil
    }
}
