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
    public let googleBannerId: String?
    public let googleInterstitialId: String?
    public let googleDynamicPriceBannerId: String?
    public let googleDynamicPriceInterstitialId: String?
    public let unityGameId: String?

    private struct InternalConfig: Decodable {
        let publisherKey: String
        let apiKey: String
        let apsAppKey: String?
        let fbNativePlacementId: String?
        let fbInterstitialPlacementId: String?
        let fbBannerPlacementId: String?
        let googleBannerId: String?
        let googleInterstitialId: String?
        let googleDynamicPriceBannerId: String?
        let googleDynamicPriceInterstitialId: String?
        let unityGameId: String?

        enum CodingKeys: String, CodingKey {
            case publisherKey = "publisher_key"
            case apiKey = "api_key"
            case apsAppKey = "aps_app_key"
            case fbNativePlacementId = "facebook_native_placement_id"
            case fbInterstitialPlacementId = "facebook_interstitial_placement_id"
            case fbBannerPlacementId = "facebook_banner_placement_id"
            case googleBannerId = "google_banner_id"
            case googleInterstitialId = "google_interstitial_id"
            case googleDynamicPriceBannerId = "google_dynamic_price_banner_id"
            case googleDynamicPriceInterstitialId = "google_dynamic_price_interstitial_id"
            case unityGameId = "unity_game_id"
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
        googleBannerId = config.googleBannerId
        googleDynamicPriceBannerId = config.googleDynamicPriceBannerId
        googleInterstitialId = config.googleInterstitialId
        googleDynamicPriceInterstitialId = config.googleDynamicPriceInterstitialId
        unityGameId = config.unityGameId
    }
}
