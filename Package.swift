// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "Manuscript",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "lint", targets: ["lint"]),
        .executable(name: "preview", targets: ["preview"]),
        .executable(name: "stylesheet", targets: ["stylesheet"]),
        .executable(name: "mock-adapter", targets: ["mock-adapter"]),
        .executable(name: "posture-probe", targets: ["posture-probe"]),
        .executable(name: "surface", targets: ["surface"])
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
        .target(name: "Gate"),
        .testTarget(name: "GateTests", dependencies: ["Gate"]),
        .target(name: "Web", dependencies: ["Gate"]),
        .executableTarget(
            name: "surface",
            dependencies: ["Web", "UserSheet", "ThemeDomain"]),
        .testTarget(
            name: "WebTests",
            dependencies: [
                "Web", "Gate", "UserSheet", "ThemeDomain", "Pigment"]),
        .target(name: "Adapter"),
        .executableTarget(name: "mock-adapter", dependencies: ["Adapter"]),
        .testTarget(
            name: "AdapterTests",
            dependencies: ["Adapter", "mock-adapter"]),
        .target(name: "Posture", dependencies: ["Adapter"]),
        .executableTarget(name: "posture-probe", dependencies: ["Posture"]),
        .testTarget(
            name: "PostureTests",
            dependencies: ["Posture", "posture-probe", "Adapter"]),
        .target(name: "Decoding"),
        .testTarget(name: "DecodingTests", dependencies: ["Decoding"]),
        .target(name: "Revision"),
        .testTarget(name: "RevisionTests", dependencies: ["Revision"]),
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
