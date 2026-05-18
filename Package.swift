// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MagRabbit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(
            name: "MagRabbit",
            targets: ["MagRabbit"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MagRabbit",
            dependencies: [],
            resources: [
                .process("Data/magazines.json")
            ]
        )
    ]
)
