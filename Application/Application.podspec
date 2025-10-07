Pod::Spec.new do |spec|
    spec.name = 'Application'
    spec.version = '1.0.0'
    spec.platform = :ios, '15.0'
    spec.swift_version = '5.0'
    spec.static_framework = true
   
    spec.author = 'Nimbus'
    spec.summary = 'Nimbus Sample Application for iOS'
    spec.homepage = 'https://www.adsbynimbus.com'
    spec.documentation_url = 'https://docs.adsbynimbus.com/docs/sdk/ios'
    spec.license = { :type => 'Copyright', :text => 'Nimbus. All rights reserved.' }
    

    spec.source = { :git => '../', :tag => '1.0.0' }
    spec.source_files = '**/*.swift'
    spec.exclude_files = '**/Package.swift'
    
    spec.dependency 'NimbusSDK', '~> 2'               # Nimbus SDK
    spec.dependency 'NimbusSDK/NimbusAPSKit'          # Amazon Publisher Services Request Support
    spec.dependency 'NimbusSDK/NimbusMetaKit'         # Meta Audience Network Request Support
    spec.dependency 'NimbusSDK/NimbusGAMKit'          # Google Ad MAnager Dynamic Price and Mediation Adapters
    spec.dependency 'NimbusSDK/NimbusUnityKit'        # Unity Ads Request Support and Renderer
    spec.dependency 'NimbusSDK/NimbusVungleKit'       # Vungle Ads Request Support and Renderer
    spec.dependency 'NimbusSDK/NimbusMobileFuseKit'   # MobileFuse Ads Request Support and Renderer (Available from 2.21.0)
    spec.dependency 'NimbusSDK/NimbusAdMobKit'        # AdMob Bidding Support (Available from 2.22.0)
    spec.dependency 'NimbusSDK/NimbusMintegralKit'    # Mintegral Support (Available from 2.24.0)
    spec.dependency 'NimbusSDK/NimbusMolocoKit'       # Moloco Support (Available from 2.29.0)
    spec.dependency 'NimbusSDK/NimbusInMobiKit'       # InMobi Support (Available from 2.31.0)
  end
