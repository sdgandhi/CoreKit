// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "CoreKit",
    products: [
        .library(name: "CoreKit", targets: ["CoreKit"])
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "CoreKit", dependencies: []),
        .testTarget(name: "CoreKitTests", dependencies: ["CoreKit"], path: "./Tests/Sources")
    ]
)
