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
        .package(
            url: "https://github.com/google-mobile-sdk/google-mobile-sdk-ios.git",
            from: "10.0.0"
        )
    ],
    targets: [
        .target(
            name: "MagRabbit",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "google-mobile-sdk-ios")
            ],
            resources: [
                .process("Data/magazines.json")
            ]
        )
    ]
)
