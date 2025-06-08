// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
        .package(path: "../Model"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "Core",
                "Domain",
                "Model",
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"],
            path: "Tests"
        ),
    ]
)
