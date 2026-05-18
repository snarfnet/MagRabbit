// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MagRabbit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MagRabbit",
            targets: ["MagRabbit"])
    ],
    dependencies: [
        // Google Mobile Ads SDK is managed via CocoaPods
    ],
    targets: [
        .target(
            name: "MagRabbit",
            dependencies: [],
            resources: [
                .process("Data/magazines.json")
            ]
        )
    ]
)
