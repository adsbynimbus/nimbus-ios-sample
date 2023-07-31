# Bazel setup

This branch demonstrates how the Nimbus SDK can be set up using Bazel.

## Bazel Installation

- Go to the Bazel iOS Tutorial: https://github.com/bazelbuild/rules_apple/blob/master/doc/tutorials/ios-app.md
- Follow the tutorial instructions to get a little familiar with Bazel
- Clone this repository to the **tutorials** directory
- Download the following dependencies and place them under `External` directory
   - `APS_iOS_SDK-4.5.6`
   - `FBAudienceNetwork` (version 6.12.0)
   - `GAM` (version 10.8.0)
      - FBLPromises.xcframework
      - GoogleAppMeasurement.xcframework
      - GoogleAppMeasurementIdentitySupport.xcframework
      - GoogleMobileAds.xcframework
      - GoogleUtilities.xcframework
      - nanopb.xcframework
      - UserMessagingPlatform.xcframework
   - `GoogleInteractiveMediaAds` (version 3.16.3)
   - `UnityAds` (version 4.4.1)
   - `VungleAdsSDK.xcframework` (version 7.0.0)
- Download [Nimbus SDK 2.12.0](https://github.com/timehop/nimbus-ios-sdk/releases/tag/2.12.0) and place it to the project root as `Nimbus-2.12.0`

## Bazel Build

To build the sample app, do the following:
- `$ cd $WORKSPACE`
- `$ bazel build //nimbus-ios-sample:nimbus_ios_sample`

## Bazel Run

Run the sample app using:

- `$ bazel run //nimbus-ios-sample:nimbus_ios_sample`

## Generate Xcode project

To generate the xcode project, run:
- `$ bazel run //nimbus-ios-sample:xcodeproj`

## IMPORTANT

- Custom fonts are disabled in the sample app due to issues linking them with Bazel
- `Keys.xcconfig` won't work, you have to place your keys directly into `Info.plist` as Bazel doesn't seem to support custom variables inside `Info.plist`

# Nimbus iOS Sample 
[![CocoaPods](https://github.com/timehop/nimbus-ios-sample/actions/workflows/cocoapods.yml/badge.svg)](https://github.com/timehop/nimbus-ios-sample/actions/workflows/cocoapods.yml)
[![Swift Package Manager](https://github.com/timehop/nimbus-ios-sample/actions/workflows/spm.yml/badge.svg)](https://github.com/timehop/nimbus-ios-sample/actions/workflows/spm.yml)

Welcome to Nimbus Sample App - ads by publishers, for publishers.

## How to clone the repository

### Install Git LFS (Large File Storage)

This repository uses git LFS. Please follow the steps below to install it:

- Open your terminal
- Run: `brew install git-lfs`
- Run: `git lfs install`

### Clone the repository

- Open your terminal
- Run: `git clone https://github.com/timehop/nimbus-ios-sample`

## How to run

- `Xcode` version must be at least 13 (min. macOS Big Sur 11.3)

### Swift Package Manager: nimbus-ios-sample

- Open `nimbus-ios-sample.xcodeproj`
- Select the `nimbus-ios-sample` target
- Run the app

#####  If you had CocoaPods installed previously, running `pod deintegrate` will prevent any possible conflicts.

### CocoaPods (requires CocoaPods >= 1.10.0): nimbus-ios-sample-pods 

- From the project root run `pod install --repo-update`
- Open the newly created `nimbus-ios-sample.xcworkspace`
- Select the `nimbus-ios-sample-pods` target
- Run the app

#####  If you run into `ambiguous for type lookup` errors, remove all package dependencies from `nimbus-ios-sample` project.

## Build Configuration: [Keys.xcconfig](Keys.xcconfig)

The Nimbus Sample App uses the [Keys.xcconfig](Keys.xcconfig) file to inject the keys and ids 
necessary to initialize the different components of the Nimbus SDK into the application's Info.plist file.

### Required Keys 
- Nimbus Sample App has already configured a publisher and API keys for testing purposes. 
- Get your `Publisher Key` and Nimbus SDK `API Key` by contacting Nimbus Support

### Optional IDs
In order to see APS/Meta/GAM/Unity examples you must also supply it's IDs
- Locate `Keys.xcconfig` file in the root project directory
- Replace the empty fields with the IDs you have

#### GAM Extra Configs
- For GAM Ads it is also required to inform the string value of your Ad Manager app ID for the key `GADApplicationIdentifier` in the Sample App plist. [GAM Update your Info.plist](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/quick-start#update_your_infoplist)
- The sample app is configured with a test `GADApplicationIdentifier` to ensure the app does not throw an exception during startup due to changes in v10 of the GoogleMobileAds SDK.
- For testing in real devices please refer to [GAM Enable test devices](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads#enable_test_devices)

### What you'll see
You will be able to see several examples categorized by specific sections, such as:
- Examples of different types of Ads
- Ads by mediation platforms (Google)
- Ads with OM SDK viewability integration
- Ad Markup Renderer

## Testing Ad Markup

The `Test Render` section of the sample app provides basic functionality for rendering ad markup using the latest
version of the Nimbus SDK. The tool provides a text input field that can receive any well-formed HTML or VAST markup
and will render the ad as a full screen ad.

1. Copy the contents of the `markup` field, without the leading or trailing quotes, from a Nimbus
   response and paste it into the input field.
2. Click the `Test` button. The markup will be rendered into a full screen container.

### Verifying Static Ads

If the container shows a blank white screen (a potential bad ad) or further verification of functionality is required:

1. Ensure the Sample app is running using the simulator.
2. Open Safari and navigate to the `Preferences` screen from the `Safari` menu.
3. Ensure the `Show Develop menu in menu bar` option is checked.
4. Find the device or simulator running the Sample app in the `Develop` menu.
5. Select the Sample app from the list of inspectable applications. 
6. In the Web Inspector window, select the Console tab and inspect the output for any errors.

##### Any errors that appear in the Web Inspector console can be ignored if the ad renders properly and there are minimal reporting discrepancies between Nimbus and the network serving the creative.

If the ad markup does not render using the test tool, first ensure that the markup pasted into the input field is valid.
For example, if the markup was obtained from a server log it may contain additional formatting characters that must be
removed or properly escaped prior to pasting it into the tool.

### Verifying Video Ads

Errors rendering a video ad can be identified by a completely black screen with the close button appearing at the
top left of the ad container.

#### Companion Ads

If the VAST creative contains a companion ad that does not render, check the size of the Companion Ad in the markup.
The `Test Render` tool is set up with a 320 by 480 end card Companion Ad by default; if another size Companion Ad is
defined in the VAST it will not render without rebuilding the Sample app with an additional Companion Ad definition
that matches the size defined in the VAST markup.

## Need help?
You can check out [Nimbus iOS Quick Start Guide](https://adsbynimbus-public.s3.amazonaws.com/iOS/docs/1.11.1/docs/index.html)

## License
Distributed under [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
