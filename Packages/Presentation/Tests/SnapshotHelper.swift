// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import SnapshotTesting
import SwiftUI

let shouldRecordSnapshots: Bool = false

@MainActor
func assertSnapshot(
    width: CGFloat = 400,
    height: CGFloat = 800,
    record: Bool = false,
    precision: Float = 1,
    delay: TimeInterval = 0,
    file: StaticString = #filePath,
    testName: String = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column,
    @ViewBuilder view: () -> some View
) {
    let view = view().frame(minWidth: width, minHeight: height)
    assertSnapshot(
        of: view,
        as: .wait(for: delay, on: .image(precision: precision)),
        record: shouldRecordSnapshots ? true : record,
        fileID: fileID,
        file: file,
        testName: testName,
        line: line,
        column: column
    )
}

func setupTesting() {
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.currency)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.wage)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.worktimes)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.payouts)

    // Don't show the "Generate Sample Data" button in the settings view to not interfere with the snapshot tests
    UserDefaults.standard.set(true, forKey: UserDefaultsKey.shouldHideGenerateSampleDataButton)

    let context = DependencyContext.current
    context.reset()
    context.register(Config.self) { Config() }
    context.register(UserData.self) { MockUserData() }
}
