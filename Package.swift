// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "Manuscript",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "lint", targets: ["lint"])
    ],
    targets: [
        .executableTarget(name: "lint"),
        .target(name: "Pigment"),
        .testTarget(name: "PigmentTests", dependencies: ["Pigment"])
    ]
)
