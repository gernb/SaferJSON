// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SaferJSON",
    products: [
        .library(
            name: "SaferJSON",
            targets: ["SaferJSON"]
        ),
    ],
    targets: [
        .target(
            name: "SaferJSON"
        ),
        .testTarget(
            name: "SaferJSONTests",
            dependencies: ["SaferJSON"]
        ),
    ]
)
