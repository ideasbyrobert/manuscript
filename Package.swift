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
        .target(name: "Typography"),
        .target(
            name: "Specimen",
            dependencies: ["ThemeDomain", "Typography", "AppleColors"]),
        .testTarget(
            name: "SpecimenTests",
            dependencies: ["Specimen", "ThemeDomain"]),
        .testTarget(name: "TypographyTests", dependencies: ["Typography"]),
        .target(name: "Pigment"),
        .testTarget(name: "PigmentTests", dependencies: ["Pigment"]),
        .target(name: "AppleColors", dependencies: ["Pigment"]),
        .testTarget(
            name: "AppleColorsTests",
            dependencies: ["AppleColors", "Pigment"]),
        .target(
            name: "ThemeDomain",
            dependencies: ["Pigment", "AppleColors"]),
        .testTarget(
            name: "ThemeDomainTests",
            dependencies: ["ThemeDomain", "Pigment", "AppleColors"])
    ]
)
