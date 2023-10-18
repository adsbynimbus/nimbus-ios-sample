# Nimbus iOS Sample 
[![CocoaPods](https://github.com/adsbynimbus/nimbus-ios-sample/actions/workflows/cocoapods.yml/badge.svg)](https://github.com/adsbynimbus/nimbus-ios-sample/actions/workflows/cocoapods.yml)
[![Swift Package Manager](https://github.com/adsbynimbus/nimbus-ios-sample/actions/workflows/spm.yml/badge.svg)](https://github.com/adsbynimbus/nimbus-ios-sample/actions/workflows/spm.yml)

Welcome to Nimbus Sample App - ads by publishers, for publishers.

## How to clone the repository

### Install Git LFS (Large File Storage)

This repository uses git LFS. Please follow the steps below to install it:

- Open your terminal
- Run: `brew install git-lfs`
- Run: `git lfs install`

### Clone the repository

- Open your terminal
- Run: `git clone https://github.com/adsbynimbus/nimbus-ios-sample`

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

#### GAM/AdMob Extra Configs
- For GAM Ads it is also required to inform the string value of your Ad Manager app ID for the key `GADApplicationIdentifier` in the Sample App plist. [GAM Update your Info.plist](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/quick-start#update_your_infoplist)
- The sample app is configured with a test `GADApplicationIdentifier` to ensure the app does not throw an exception during startup due to changes in v10 of the GoogleMobileAds SDK.
- For testing in real devices please refer to [GAM Enable test devices](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads#enable_test_devices)

##### Switch between GAM and AdMob

By default, if you navigate to **Mediation Platforms** you will see **AdMob** section examples. 

In order to see GAM examples in the same section, you need to:
- Open `Info.plist`
- Change **GADIsAdManagerApp** to **YES**
- Re-run the app

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

## Troubleshooting

### Unable to boot device because it cannot be located on disk

If you ever see this pop-up error in Xcode, quit all your running simulators, open your terminal and erase all contents and settings of all simulators using: `xcrun simctl erase all`

### Build failed because Application.swiftmodule is missing a required architecture

It's possible you experience this error when trying to run the sample app via cocoapods and the `nimbus-ios-sample-pods` scheme. It's likely caused by a corrupted CocoaPods installation. 
You can check whether it's the case by navigating to the project file and selecting the `nimbus-ios-sample-pods` target. Once you're there:

- Click on Build Settings
- Make sure **All** in the secondary top bar is checked
- Type **excluded architectures** in the search bar in the top right corner
- If there's more than one architecture, especially the one your computer runs on, it's likely the problem. E.g. you run on ARM64 (Apple Silicon) and you see `arm64`

#### How to fix it

##### Uninstall CocoaPods

- List the coocapods packages: `gem list --local | grep cocoapods`
- Uninstall every single one of them, e.g. `sudo gem uninstall cocoapods`
- Once you uninstalled everything, delete the local cocoapods directory: `rm -rf ~/.cocoapods`

##### Install CocoaPods

- Run `sudo gem install cocoapods`

##### Clean the nimbus-ios-sample changes

- Navigate to nimbus-ios-sample directory
- Run `git checkout -f` to purge any project changes cocoapods previously did
- Delete the xcworkspace `rm -rf nimbus-ios-sample.xcworkspace`
- Delete the `Podfile.lock` using `rm Podfile.lock`
- Delete the Pods directory: `rm -rf Pods`

##### Re-initialize nimbus-ios-sample using cocoapods

- Run `pod install --repo-update`
- Open the `nimbus-ios-sample.xcworkspace`
- Clean the build using `CMD + Shift + K`
- Try to run the `nimbus-ios-sample-pods` scheme. Everything should work.

## Need help?
You can check out [Nimbus iOS Quick Start Guide](https://adsbynimbus-public.s3.amazonaws.com/iOS/docs/1.11.1/docs/index.html)

## License
Distributed under [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
