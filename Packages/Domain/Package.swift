// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Model"),
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                "Core",
                "Model",
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            path: "Tests"
        ),
    ]
)
