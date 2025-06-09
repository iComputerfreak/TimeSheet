// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
        .package(path: "../Model"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.4"),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                "Core",
                "Domain",
                "Model",
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: [
                "Presentation",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            path: "Tests"
        ),
    ]
)
