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
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-sdk", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-admob", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-aps", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-inmobi", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-liveramp", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-meta", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-mintegral", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-mobilefuse", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-moloco", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-unity", from: "3.0.0"),
        .package(url: "https://github.com/adsbynimbus/nimbus-ios-vungle", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [
                .product(name: "NimbusKit", package: "nimbus-ios-sdk"),
                .product(name: "NimbusAPSKit", package: "nimbus-ios-aps"),
                .product(name: "NimbusMetaKit", package: "nimbus-ios-meta"),
                .product(name: "NimbusVungleKit", package: "nimbus-ios-vungle"),
                .product(name: "NimbusUnityKit", package: "nimbus-ios-unity"),
                .product(name: "NimbusMobileFuseKit", package: "nimbus-ios-mobilefuse"),
                .product(name: "NimbusAdMobKit", package: "nimbus-ios-admob"),
                .product(name: "NimbusMintegralKit", package: "nimbus-ios-mintegral"),
                .product(name: "NimbusMolocoKit", package: "nimbus-ios-moloco"),
                .product(name: "NimbusInMobiKit", package: "nimbus-ios-inmobi")
            ],
            path: "Sources")
    ]
)
