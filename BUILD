load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application", "ios_framework")
load("@build_bazel_rules_apple//apple:apple.bzl", "apple_dynamic_xcframework_import", "apple_static_xcframework_import")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

# FAN
apple_dynamic_xcframework_import(
    name = "FBAudienceNetwork",
    xcframework_imports = glob(["External/FBAudienceNetwork/FBAudienceNetwork.xcframework/**"])
)

# GAM
apple_static_xcframework_import(
    name = "GoogleMobileAds",
    xcframework_imports = glob(["External/GAM/GoogleMobileAds.xcframework/**"])
)
apple_static_xcframework_import(
    name = "FBLPromises",
    xcframework_imports = glob(["External/GAM/FBLPromises.xcframework/**"])
)
apple_static_xcframework_import(
    name = "GoogleAppMeasurement",
    xcframework_imports = glob(["External/GAM/GoogleAppMeasurement.xcframework/**"])
)
apple_static_xcframework_import(
    name = "GoogleAppMeasurementIdentitySupport",
    xcframework_imports = glob(["External/GAM/GoogleAppMeasurementIdentitySupport.xcframework/**"])
)
apple_static_xcframework_import(
    name = "GoogleUtilities",
    xcframework_imports = glob(["External/GAM/GoogleUtilities.xcframework/**"])
)
apple_static_xcframework_import(
    name = "nanopb",
    xcframework_imports = glob(["External/GAM/nanopb.xcframework/**"])
)
apple_static_xcframework_import(
    name = "UserMessagingPlatform",
    xcframework_imports = glob(["External/GAM/UserMessagingPlatform.xcframework/**"])
)

# IMA
apple_dynamic_xcframework_import(
    name = "GoogleInteractiveMediaAds",
    xcframework_imports = glob(["External/GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.xcframework/**"])
)

# UnityAds
apple_static_xcframework_import(
    name = "UnityAds",
    xcframework_imports = glob(["External/UnityAds/UnityAds.xcframework/**"])
)

# Vungle
apple_dynamic_xcframework_import(
    name = "VungleAdsSDK",
    xcframework_imports = glob(["External/VungleAdsSDK.xcframework/**"])
)

# DTBiOSSDK
apple_dynamic_xcframework_import(
    name = "DTBiOSSDK",
    xcframework_imports = glob(["External/APS_iOS_SDK-4.5.6/DTBiOSSDK.xcframework/**"])
)

# OMSDK
apple_dynamic_xcframework_import(
    name = "OMSDK_Adsbynimbus",
    xcframework_imports = glob(["Nimbus-2.12.0/OMSDK_Adsbynimbus.xcframework/**"])
)

# Nimbus SDK
apple_dynamic_xcframework_import(
    name = "NimbusKit",
    deps = [":NimbusRequestKit", ":NimbusRenderKit"],
    xcframework_imports = glob(["Nimbus-2.12.0/NimbusKit.xcframework/**"])
)

apple_dynamic_xcframework_import(
    name = "NimbusCoreKit",
    xcframework_imports = glob(["Nimbus-2.12.0/NimbusCoreKit.xcframework/**"])
)

apple_dynamic_xcframework_import(
    name = "NimbusRequestKit",
    deps = [":NimbusCoreKit"],
    xcframework_imports = glob(["Nimbus-2.12.0/NimbusRequestKit.xcframework/**"])
)

apple_dynamic_xcframework_import(
    name = "NimbusRenderKit",
    deps = [":NimbusCoreKit", ":OMSDK_Adsbynimbus"],
    xcframework_imports = glob(["Nimbus-2.12.0/NimbusRenderKit.xcframework/**"])
)

apple_dynamic_xcframework_import(
    name = "NimbusRenderStaticKit",
    xcframework_imports = glob(["Nimbus-2.12.0/NimbusRenderStaticKit.xcframework/**"])
)

apple_dynamic_xcframework_import(
    name = "NimbusRenderVideoKit",
    deps = [":GoogleInteractiveMediaAds"],
    xcframework_imports = glob(["Nimbus-2.12.0/NimbusRenderVideoKit.xcframework/**"])
)

apple_dynamic_xcframework_import(
    name = "NimbusRequestAPSKit",
    deps = [":DTBiOSSDK"],
    xcframework_imports = glob(["Nimbus-2.12.0/NimbusRequestAPSKit.xcframework/**"])
)

# Nimbus built from sources

# NimbusRequestFANKit
swift_library(
    name = "NimbusRequestFANKit",
    module_name = "NimbusRequestFANKit",
    srcs = glob(["Nimbus-2.12.0/NimbusFAN/NimbusRequestFANKit/**"]),
    deps = [":NimbusRequestKit", ":FBAudienceNetwork"],
    visibility = ["//visibility:private"],    
)

# NimbusRenderFANKit
swift_library(
    name = "NimbusRenderFANKit",
    module_name = "NimbusRenderFANKit",
    srcs = glob(["Nimbus-2.12.0/NimbusFAN/NimbusRenderFANKit/**"]),
    deps = [":NimbusRenderKit", ":FBAudienceNetwork"],
    visibility = ["//visibility:private"],
)

# NimbusGAMKit
swift_library(
    name = "NimbusGAMKit",
    module_name = "NimbusGAMKit",
    srcs = glob(["Nimbus-2.12.0/NimbusGAM/NimbusGAMKit/**"]),
    deps = [
        ":NimbusKit", 
        ":FBLPromises", 
        ":GoogleAppMeasurement", 
        ":GoogleAppMeasurementIdentitySupport",
        ":GoogleMobileAds",
        ":GoogleUtilities",
        ":nanopb",
        ":UserMessagingPlatform",
    ],
    visibility = ["//visibility:private"],
)

# NimbusUnityKit
swift_library(
    name = "NimbusUnityKit",
    module_name = "NimbusUnityKit",
    srcs = glob(["Nimbus-2.12.0/NimbusUnity/NimbusUnityKit/**"]),
    deps = [":NimbusRequestKit", ":NimbusRenderKit", ":UnityAds"],
    visibility = ["//visibility:private"],
)

# NimbusVungleKit
swift_library(
    name = "NimbusVungleKit",
    module_name = "NimbusVungleKit",
    srcs = glob(["Nimbus-2.12.0/NimbusVungle/NimbusVungleKit/**"]),
    deps = [":NimbusRequestKit", ":NimbusRenderKit", ":VungleAdsSDK"],
    visibility = ["//visibility:private"],
)

swift_library(
    name = "Application",
    module_name = "Application",
    srcs = glob(["Application/Sources/**"]),
    deps = [
        ":NimbusKit",
        ":NimbusRenderStaticKit",
        ":NimbusRenderVideoKit",
        ":NimbusRequestAPSKit",
        ":NimbusRequestFANKit",
        ":NimbusRenderFANKit",
        ":NimbusGAMKit",
        ":NimbusUnityKit",
        ":NimbusVungleKit",
    ],
    visibility = ["//visibility:private"],
)

swift_library(
    name = "sources",
    srcs = glob(["SceneDelegate.swift"]),
    deps = [":Application"],
    visibility = ["//visibility:private"],
)

# iOS App

ios_application(
    name = "nimbus_ios_sample",    
    deps = [
        ":sources",
    ],
    bundle_id = "com.adsbynimbus.ios.NimbusDemo",
    bundle_name = "nimbus_ios_sample",
    families = [
        "iphone",
        "ipad",
    ],
    minimum_os_version = "15.0",
    visibility = ["//visibility:public"],    
    infoplists = ["Resources/Info.plist"],
    launch_storyboard = "Resources/Launch Screen.storyboard",
    linkopts = ["-ObjC"],
    resources = glob(["Resources/**"], exclude = ["Info.plist", "Launch Screen.storyboard"])
)

# Xcode project

load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcodeproj",
)

xcodeproj(
    name = "xcodeproj",
    build_mode = "bazel",
    project_name = "nimbus_ios_sample",
    tags = ["manual"],
    top_level_targets = [
        ":nimbus_ios_sample",
    ],
)