// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "Manuscript",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "lint", targets: ["lint"]),
        .executable(name: "preview", targets: ["preview"]),
        .executable(name: "stylesheet", targets: ["stylesheet"])
    ],
    targets: [
        .executableTarget(name: "lint"),
        .testTarget(name: "lintTests", dependencies: ["lint"]),
        .executableTarget(
            name: "preview",
            dependencies: ["Specimen", "ThemeDomain"]),
        .target(name: "Cascade"),
        .testTarget(name: "CascadeTests", dependencies: ["Cascade"]),
        .target(
            name: "Highlighters",
            dependencies: ["Cascade", "ThemeDomain"]),
        .testTarget(
            name: "HighlightersTests",
            dependencies: ["Highlighters", "Cascade", "ThemeDomain"]),
        .target(
            name: "UserSheet",
            dependencies: [
                "Cascade", "Highlighters", "ThemeDomain",
                "AppleColors"]),
        .testTarget(
            name: "UserSheetTests",
            dependencies: ["UserSheet", "Cascade", "ThemeDomain"]),
        .executableTarget(
            name: "stylesheet",
            dependencies: ["UserSheet", "ThemeDomain"]),
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
