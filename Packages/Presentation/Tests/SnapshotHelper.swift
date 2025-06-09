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
) async {
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

func registerTestingDependencies() {
    let context = DependencyContext.current
    context.reset()
    context.register(Config.self) { Config() }
    context.register(UserData.self) { UserData() }
}
