source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'

target 'nimbus-ios-sample-pods' do
  use_frameworks!

  pod 'Application', :path => 'Application'

  pod 'NimbusSDK', '~> 2.16', subspecs: [
     'NimbusKit',               # Nimbus SDK
     'NimbusRenderStaticKit',   # Static Ad Renderer
     'NimbusRenderVideoKit',    # Video Ad Renderer
     'NimbusRequestAPSKit',     # Amazon Publisher Services Request Support
     'NimbusRequestFANKit',     # Meta Audience Network Request Support
     'NimbusRenderFANKit',      # Meta Audience Network Ad Renderer
     'NimbusGAMKit',            # Google Ad Manager Dynamic Price and Mediation Adapters
     'NimbusGoogleKit',         # Google AdMob Dynamic Price and Mediation Adapters
     'NimbusUnityKit',          # Unity Ads Request Support and Renderer
     'NimbusVungleKit',         # Vungle Ads Request Support and Renderer
     'NimbusLiveRampKit'        # LiveRamp Request Support
   ]
end
