// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Vellum",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "Vellum",
            targets: ["Vellum"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "3.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0")
    ],
    targets: [
        .target(
            name: "Vellum",
            dependencies: [],
            path: "Vellum/Classes"
        ),
        .testTarget(
            name: "VellumTests",
            dependencies: ["Vellum", "Quick", "Nimble"],
            path: "Example/Tests",
            exclude: ["Info.plist"]
        )
    ]
)
