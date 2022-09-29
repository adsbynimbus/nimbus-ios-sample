//
//  ConfigManager.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 11/11/21.
//

import Foundation

public final class ConfigManager {
    public static let shared = ConfigManager()
    
    public let publisherKey: String
    public let apiKey: String
    
    public let apsAppKey: String?
    
    public let fbNativePlacementId: String?
    public let fbInterstitialPlacementId: String?
    public let fbBannerPlacementId: String?
    
    public let googlePlacementId: String?
    
    public let unityGameId: String?
    
    public let liveRampConfigId: String?
    
    public let vungleAppId: String?
    public let vungleBannerPlacementId: String?
    public let vungleMRECPlacementId: String?
    public let vungleInterstitialPlacementId: String?
    public let vungleRewardedPlacementId: String?
    public let vungleNativePlacementId: String?
    
    private struct InternalConfig: Decodable {
        let publisherKey: String
        let apiKey: String
        
        let apsAppKey: String?
        
        let fbNativePlacementId: String?
        let fbInterstitialPlacementId: String?
        let fbBannerPlacementId: String?
        
        let googlePlacementId: String?
        
        let unityGameId: String?
        
        let liveRampConfigId: String?
        
        let vungleAppId: String?
        let vungleBannerPlacementId: String?
        let vungleMRECPlacementId: String?
        let vungleInterstitialPlacementId: String?
        let vungleRewardedPlacementId: String?
        let vungleNativePlacementId: String?
        
        enum CodingKeys: String, CodingKey {
            
            case publisherKey = "publisher_key"
            case apiKey = "api_key"
            
            case apsAppKey = "aps_app_key"
            
            case fbNativePlacementId = "facebook_native_placement_id"
            case fbInterstitialPlacementId = "facebook_interstitial_placement_id"
            case fbBannerPlacementId = "facebook_banner_placement_id"
            
            case googlePlacementId = "google_placement_id"
            
            case unityGameId = "unity_game_id"
            
            case liveRampConfigId = "live_ramp_config_id"
            
            case vungleAppId = "vungle_app_id"
            case vungleBannerPlacementId = "vungle_banner_placement_id"
            case vungleMRECPlacementId = "vungle_mrec_placement_id"
            case vungleInterstitialPlacementId = "vungle_interstitial_placement_id"
            case vungleRewardedPlacementId = "vungle_rewarded_placement_id"
            case vungleNativePlacementId = "vungle_native_placement_id"
        }
    }

    private init() {
        let url = Bundle.main.url(forResource: "secrets", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let config = try! JSONDecoder().decode(InternalConfig.self, from: data)

        publisherKey = config.publisherKey
        apiKey = config.apiKey
        
        apsAppKey = config.apsAppKey
        
        fbNativePlacementId = config.fbNativePlacementId
        fbInterstitialPlacementId = config.fbInterstitialPlacementId
        fbBannerPlacementId = config.fbBannerPlacementId
        
        googlePlacementId = config.googlePlacementId
        
        unityGameId = config.unityGameId
        
        liveRampConfigId = config.liveRampConfigId
        
        vungleAppId = config.vungleAppId
        vungleBannerPlacementId = config.vungleBannerPlacementId
        vungleMRECPlacementId = config.vungleMRECPlacementId
        vungleInterstitialPlacementId = config.vungleInterstitialPlacementId
        vungleRewardedPlacementId = config.vungleRewardedPlacementId
        vungleNativePlacementId = config.vungleNativePlacementId
    }
}
