// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DSComponents",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DSComponents",
            targets: ["DSComponents"]),
    ],
    targets: [
        .target(
            name: "DSComponents",
            resources: [
                .process("Supporting")
            ]
        ),
        .testTarget(
            name: "DSComponentsTests",
            dependencies: ["DSComponents"]
        ),
    ]
)
