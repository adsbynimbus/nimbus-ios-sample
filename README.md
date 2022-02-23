# Nimbus iOS Sample

Welcome to Nimbus Sample App - ads by publishers, for publishers.

## Build Setup

### Requeriments
- `XCode` version must be at least 13 (min. macOS Big Sur 11.3)
- `NimbusSDK` and it's subspecs requires Cocoapods >= 1.10.0

### Installation
After cloning this repo, run `pod install` in the root folder

### Required Keys
- Nimbus Sample App has already configured a publisher and API keys for testing purposes. Get your `Publisher Key` and Nimbus SDK `API Key` by contacting Nimbus Support
- These keys are configured in the `secrets.json` file at `Config` folder

### Optional IDs
In order to see APS/FAN/MoPub/GAM/Unity examples you must also supply it's IDs
- Locate `secrets.json` file at `Config` folder
- Replace the empty fields with the IDs you have

#### GAM Extra Configs
- For GAM Ads it is also required to inform the string value of your Ad Manager app ID for the key `GADApplicationIdentifier` in the Sample App plist. [GAM Update your Info.plist](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/quick-start#update_your_infoplist)
- For testing in real devices please refer to [GAM Enable test devices](https://developers.google.com/ad-manager/mobile-ads-sdk/ios/test-ads#enable_test_devices)

## How to run
After running `pod install` and setting up the required keys you're good to go
- Locale `nimbus-ios-sample.xcworkspace`
- Open it with `XCode`
- Run the app

### What you'll see
You will be able to see several examples categorized by specific sections, such as:
- Examples of different types of Ads
- Ads by mediation platforms (Google, MoPub)
- Ads with MOAT viewability integration
- Ad Markup Renderer

## Need help?
You can check out [Nimbus iOS Quick Start Guide](https://adsbynimbus-public.s3.amazonaws.com/iOS/docs/1.11.1/docs/index.html)

## License
Distributed under [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
