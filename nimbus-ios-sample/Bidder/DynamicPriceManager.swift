//
//  DynamicPriceManager.swift
//  ClientSideHeaderBidder
//
//  Created by Inder Dhir on 7/26/22.
//

import GoogleMobileAds

final class DynamicPriceManager {
    
    let bidders: [Bidder]
    let refreshInterval: TimeInterval
    let requestBuilder: () -> GAMRequest
    var lastRequestTime: TimeInterval = 0
    var callback: ((GAMRequest) -> Void)?
    var autoRefreshTask: Task<Void, Error>?
    var isAutoRefreshingEnabled = true
    
    init(
        bidders: [Bidder],
        refreshInterval: TimeInterval = 30,
        requestBuilder: @escaping () -> GAMRequest = { GAMRequest() }
    ) {
        self.bidders = bidders
        self.refreshInterval = refreshInterval
        self.requestBuilder = requestBuilder
    }
    
    func autoRefresh(_ callback: @escaping (GAMRequest) -> Void) {
        self.callback = callback
        
        if isAutoRefreshingEnabled {
            setupNotifications()
        }
        setupAutoRefreshingTask()
    }
    
    func cancelRefresh() {
        autoRefreshTask?.cancel()
    }
    
    private func auction() async throws -> GAMRequest {
        let sleepInSec = (refreshInterval - (Date().timeIntervalSince1970 - lastRequestTime))
        if sleepInSec > 0 {
            try await Task.sleep(nanoseconds: UInt64(sleepInSec * 1_000_000_000))
        }
        
        lastRequestTime = Date().timeIntervalSince1970
        
        let bids = await getBids()
        
        let request = requestBuilder()
        if request.customTargeting == nil { request.customTargeting = [:] }
        bids.forEach { $0.applyTargeting(for: request) }
        
        // GAM request now has all the custom targeting applied from APS and Nimbus
        return request
    }
    
    private func getBids() async -> [Bid] {
        return await withTaskGroup(of: Optional<Bid>.self, returning: [Bid].self) { group in
            for bidder in bidders {
                group.addTask {
                    guard let bid = try? await bidder.fetchBid() else {
                        return nil
                    }
                    return bid
                }
            }
            
            var bids: [Bid] = []
            for await bid in group.compactMap({ $0 }) {
                bids.append(bid)
            }
            return bids
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc private func appDidBecomeActive() {
        setupAutoRefreshingTask()
    }
    
    @objc private func appWillResignActive() {
        autoRefreshTask?.cancel()
    }
    
    private func setupAutoRefreshingTask() {
        autoRefreshTask = Task {
            while !Task.isCancelled {
                callback?(try await auction())
            }
        }
    }
}

struct TimedOutError: Error, Equatable {}
