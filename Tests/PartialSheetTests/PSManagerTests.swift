import XCTest
import SwiftUI
@testable import PartialSheet

final class PSManagerTests: XCTestCase {
    @MainActor
    private func present(_ manager: PSManager, owner: UUID, shown: Bool = true,
                         onDismiss: @escaping () -> Void = {}) {
        manager.updatePartialSheet(owner: owner, isPresented: shown, type: .dynamic,
                                   iPhoneStyle: .defaultStyle(), iPadMacStyle: .defaultStyle(),
                                   slideAnimation: nil, content: { Text("Sheet") }, onDismiss: onDismiss)
    }

    func testDismissCallbackRunsOnceForBindingAndGestureDismissal() async {
        await MainActor.run {
            let manager = PSManager()
            var calls = 0
            present(manager, owner: UUID(), onDismiss: { calls += 1 })
            manager.isPresented = false // Native sheet's binding.
            manager.dismiss() // A second dismissal must be harmless.
            XCTAssertEqual(calls, 1)
            XCTAssertNil(manager.owner)
        }
    }

    func testOldPresenterCannotDismissReplacement() async {
        await MainActor.run {
            let manager = PSManager()
            let first = UUID(), second = UUID()
            var calls = 0
            present(manager, owner: first, onDismiss: { calls += 1 })
            present(manager, owner: second)
            present(manager, owner: first, shown: false)
            XCTAssertEqual(calls, 1)
            XCTAssertTrue(manager.isPresented)
            XCTAssertEqual(manager.owner, second)
        }
    }

    func testProgrammaticDismissalNotifiesPresenter() async {
        await MainActor.run {
            let manager = PSManager()
            let owner = UUID()
            var calls = 0
            present(manager, owner: owner, onDismiss: { calls += 1 })
            present(manager, owner: owner, shown: false)
            XCTAssertFalse(manager.isPresented)
            XCTAssertEqual(calls, 1)
        }
    }

    func testRapidReopenSurvivesOldCleanupDeadline() async throws {
        let manager = await MainActor.run { PSManager() }
        let owner = UUID()
        await MainActor.run {
            present(manager, owner: UUID())
            manager.dismiss()
            present(manager, owner: owner)
        }
        try await Task.sleep(nanoseconds: 500_000_000)
        await MainActor.run {
            XCTAssertTrue(manager.isPresented)
            XCTAssertEqual(manager.owner, owner)
        }
    }
}
