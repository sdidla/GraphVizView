// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphVizView",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .visionOS(.v1),
        .macCatalyst(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "GraphVizView", targets: ["GraphVizView"]),
    ],
    targets: [
        .target(
            name: "GraphVizView",
            resources: [
                .process("Resources/viz-standalone.js")
            ]
        ),
        .testTarget(name: "GraphVizViewTests", dependencies: ["GraphVizView"]),
    ]
)
