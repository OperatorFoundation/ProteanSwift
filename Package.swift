// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProteanSwift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ProteanSwift",
            targets: ["ProteanSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/OperatorFoundation/Datable.git", from: "1.0.1"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ProteanSwift",
            dependencies: ["Datable", "CryptoSwift"]),
        .testTarget(
            name: "ProteanSwiftTests",
            dependencies: ["ProteanSwift", "Datable"]),
    ]
)
