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
    dependencies: [
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", .upToNextMajor(from: "5.3.0"))
    ],
    targets: [
        .target(
            name: "DSComponents",
            dependencies: [
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ],
            resources: [
                .process("Supporting/Resources")
            ]
        ),
        .testTarget(
            name: "DSComponentsTests",
            dependencies: ["DSComponents"]
        )
    ]
)
