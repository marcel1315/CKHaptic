// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "CKHaptic",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "CKHaptic", targets: ["CKHaptic"])
    ],
    targets: [
        .target(name: "CKHaptic", path: "CKHaptic/Classes")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)