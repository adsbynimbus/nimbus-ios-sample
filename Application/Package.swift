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
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-sdk.git", from: "2.22.0"),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "NimbusKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusRenderKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusRequestKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusRenderStaticKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusRenderVideoKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusRequestAPSKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusGAMKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusGoogleKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusFANKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusVungleKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusUnityKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusMobileFuseKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusAdMobKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusMintegralKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusMolocoKit", package: "nimbus-ios-sdk")
            ],
            path: "Sources")
    ]
)
