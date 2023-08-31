// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EpubReaderLight",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "EpubReaderLight",
            targets: ["EpubReaderLight"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "EpubReaderLight",
            resources: [
                .process("Resources/Web")
            ]
        ),
        .testTarget(
            name: "EpubReaderLightTests",
            dependencies: ["EpubReaderLight"]
        )
    ]
)
