// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]
        ),
    ],
    dependencies: [
        // In theory, this package is allowed to depend on "Model", but right now it's not necessary.
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"],
            path: "Tests"
        ),
    ]
)
