//
//  Bidder.swift
//  ClientSideHeaderBidder
//
//  Created by Inder Dhir on 7/21/22.
//

import NimbusKit
import NimbusCoreKit
import NimbusRequestAPSKit
import GoogleMobileAds
import NimbusSDK

enum Bid {
    case nimbus(NimbusAd)
    case aps(DTBAdResponse)
    
    func applyTargeting(for request: GAMRequest) {
        switch self {
        case let .aps(response):
            response.applyTargeting(into: request)
        case let .nimbus(ad):
            ad.applyTargeting(into: request)
        }
    }
}

protocol Bidder {
    func fetchBid() async throws -> Bid
}

final class NimbusBidder: Bidder {
    
    private let request: NimbusRequest
    private let mapping: NimbusDynamicPriceMapping?
    private let requestManager = NimbusRequestManager()
    private var continuation: CheckedContinuation<Bid, Error>?
    
    init(request: NimbusRequest, mapping: NimbusDynamicPriceMapping? = nil) {
        self.request = request
        self.mapping = mapping
        requestManager.delegate = self
    }
    
    func fetchBid() async throws -> Bid {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.continuation = continuation
            
            print("NimbusBidder startNimbus")
            self?.requestManager.performRequest(request: request)
        }
    }
}

extension NimbusBidder: NimbusRequestManagerDelegate {
    func didCompleteNimbusRequest(request: NimbusRequest, ad: NimbusAd) {
        print("NimbusBidder didCompleteNimbusRequest")
        continuation?.resume(returning: .nimbus(ad))
    }
    
    func didFailNimbusRequest(request: NimbusRequest, error: NimbusError) {
        print("NimbusBidder didFailNimbusRequest")
        continuation?.resume(throwing: error)
    }
}


final class APSBidder: Bidder, DTBAdCallback {
    
    let adLoader: DTBAdLoader
    var continuation: CheckedContinuation<DTBAdResponse, Error>?
    
    init(adLoader: DTBAdLoader) {
        self.adLoader = adLoader
    }
    
    func fetchBid() async throws -> Bid {
        try await .aps(loadAd())
    }
    
    private func loadAd() async throws -> DTBAdResponse {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let `self` = self else { return }
            
            self.continuation = continuation
            
            print("APSBidder startAPS")
            self.adLoader.loadAd(self)
        }
    }
    
    func onSuccess(_ adResponse: DTBAdResponse!) {
        print("APSBidder onSuccess")
        continuation?.resume(returning: adResponse)
    }
    
    func onFailure(_ error: DTBAdError) {
        print("APSBidder onFailure \(error.rawValue)")
        continuation?.resume(throwing: NimbusRenderError.adRenderingFailed(message: ""))
    }
}

private extension DTBAdResponse {
    func applyTargeting(into request: GAMRequest) {
        if let customTargeting = customTargeting() {
            request.customTargeting?.merge(customTargeting, uniquingKeysWith: { (_, new) in new })
        }
    }
}

private extension NimbusAd {
    func applyTargeting(into request: GAMRequest, mapping: NimbusGAMLinearPriceMapping = NimbusGAMLinearPriceMapping.banner()) {
        request.customTargeting?["na_id"] = auctionId
        request.customTargeting?["na_network"] = network
        
        if auctionType == .video {
            request.customTargeting?["na_bid_video"] = mapping.getKeywords(ad: self)
            
            if let duration = duration {
                request.customTargeting?["na_duration"] = String(duration)
            }
        } else {
            request.customTargeting?["na_bid"] = mapping.getKeywords(ad: self)
        }
    }
}
