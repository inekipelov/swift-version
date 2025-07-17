// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-version",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "Version", targets: ["Version"]),
    ],
    targets: [
        .target(name: "Version", dependencies: [], path: "Sources"),
        .testTarget(name: "VersionTests", dependencies: ["Version"], path: "Tests"),
    ]
)
