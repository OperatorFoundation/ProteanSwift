// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProteanSwift",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "ProteanSwift", targets: ["ProteanSwift"])],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "3.0.5"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "ProteanSwift",
            dependencies: ["Datable", "CryptoSwift"]),
        .testTarget(
            name: "ProteanSwiftTests",
            dependencies: ["ProteanSwift", "Datable"]),
    ],
    swiftLanguageVersions: [.v5]
)
