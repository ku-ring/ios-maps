// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "package-kuring-maps",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(
            name: "KuringMapsLink",
            targets: ["KuringMapsLink"]
        ),
        .library(
            name: "KuringMapsUI",
            targets: ["KuringMapsUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ku-ring/the-satellite", branch: "main"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
    ],
    targets: [
        .target(
            name: "KuringMapsLink",
            dependencies: [
                .product(name: "Satellite", package: "the-satellite")
            ],
            resources: [
                .process("Resources/place.json")
            ]
        ),
        .target(
            name: "KuringMapsUI",
            dependencies: ["KuringMapsLink"],
            resources: [
                .process("Resources/Assets.xcassets")
            ]
        ),
        .testTarget(
            name: "KuringMapsLinkTests",
            dependencies: ["KuringMapsLink"]),
    ]
)
