// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Model",
            targets: ["Model"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Model",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model"],
            path: "Tests"
        ),
    ]
)
