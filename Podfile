source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'

target 'nimbus-ios-sample-pods' do
  use_frameworks!

  pod 'Application', :path => 'Application'

  pod 'NimbusSDK', '~> 2', subspecs: [
     'NimbusKit',               # Nimbus SDK
     'NimbusAPSKit',            # Amazon Publisher Services Request Support
     'NimbusMetaKit',           # Meta Audience Network Request Support
     'NimbusGAMKit',            # Google Ad Manager Dynamic Price and Mediation Adapters
     'NimbusUnityKit',          # Unity Ads Request Support and Renderer
     'NimbusVungleKit',         # Vungle Ads Request Support and Renderer
     'NimbusLiveRampKit',       # LiveRamp Request Support
     'NimbusMobileFuseKit',     # MobileFuse Ads Request Support and Renderer (Available from 2.21.0)
     'NimbusAdMobKit',          # AdMob Bidding Support (Available from 2.22.0)
     'NimbusMintegralKit',      # Mintegral Support (Available from 2.24.0)
     'NimbusMolocoKit',         # Moloco Support (Available from 2.29.0)
     'NimbusInMobiKit'          # InMobi Support (Available from 2.31.0)
   ]
end
