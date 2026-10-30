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
    
    spec.dependency 'NimbusSDK', '~> 3'                           # Nimbus SDK
    spec.dependency 'NimbusAdMobKit', '~> 13'                     # AdMob Bidding Support
    spec.dependency 'NimbusAPSKit', '~> 5'                        # Amazon Publisher Services Request Support
    spec.dependency 'NimbusDisplayIOKit', '~> 4'                  # display.io Support
    spec.dependency 'NimbusDTKit', '~> 8'                         # Digital Turbine Support
    spec.dependency 'NimbusInMobiKit', '~> 11'                    # InMobi Support
    spec.dependency 'NimbusMetaKit', '~> 6'                       # Meta Audience Network Request Support
    spec.dependency 'NimbusMintegralKit', '~> 8'                  # Mintegral Support
    spec.dependency 'NimbusMobileFuseKit', '~> 1'                 # MobileFuse Ads Request Support and Renderer
    spec.dependency 'NimbusMolocoKit', '~> 4'                     # Moloco Support
    spec.dependency 'NimbusUnityKit', '~> 4'                      # Unity Ads Request Support and Renderer
    spec.dependency 'NimbusVungleKit', '~> 7'                     # Vungle Ads Request Support and Renderer
  end
