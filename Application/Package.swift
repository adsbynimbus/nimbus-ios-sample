// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "nimbus-ios-sample",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Application",
            targets: ["Application"]),
    ],
    dependencies: [
        .package(name: "nimbus-ios-sdk", path: "../.."),
        //.package(url: "https://github.com/timehop/nimbus-ios-sdk.git", exact: "2.15.3"),
        .package(url: "https://github.com/LiveRamp/ats-sdk-ios.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "Nimbus", package: "nimbus-ios-sdk"),
                .product(name: "NimbusRequestAPSKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusLiveRampKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusGAMKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusGoogleKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusFANKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusVungleKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusUnityKit", package: "nimbus-ios-sdk"),
            ],
            path: "Sources")
    ]
)
