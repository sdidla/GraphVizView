// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphVizWebView",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
        .visionOS(.v1),
        .macOS(.v13)
    ],
    products: [
        .library(name: "GraphVizWebView", targets: ["GraphVizWebView"]),
    ],
    targets: [
        .target(
            name: "GraphVizWebView",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(name: "GraphVizWebViewTests", dependencies: ["GraphVizWebView"]),
    ]
)
