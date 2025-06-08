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
            dependencies: ["Presentation"],
            path: "Tests"
        ),
    ]
)
