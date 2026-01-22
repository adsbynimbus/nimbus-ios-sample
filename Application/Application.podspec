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
    
    spec.dependency 'NimbusSDK', '~> 3'               # Nimbus SDK
    spec.dependency 'NimbusAPSKit', '~> 3'            # Amazon Publisher Services Request Support
    spec.dependency 'NimbusMetaKit', '~> 3'           # Meta Audience Network Request Support
    spec.dependency 'NimbusUnityKit', '~> 3'          # Unity Ads Request Support and Renderer
    spec.dependency 'NimbusVungleKit', '~> 3'         # Vungle Ads Request Support and Renderer
    spec.dependency 'NimbusMobileFuseKit', '~> 3'     # MobileFuse Ads Request Support and Renderer
    spec.dependency 'NimbusAdMobKit', '~> 3'          # AdMob Bidding Support
    spec.dependency 'NimbusMintegralKit', '~> 3'      # Mintegral Support
    spec.dependency 'NimbusMolocoKit', '~> 3'         # Moloco Support
    spec.dependency 'NimbusInMobiKit', '~> 3'         # InMobi Support
  end
