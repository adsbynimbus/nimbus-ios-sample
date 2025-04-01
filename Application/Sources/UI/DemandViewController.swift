//
//  DemandViewController.swift
//  Nimbus
//  Created on 10/31/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import UIKit
import NimbusKit

class DemandViewController: SampleAdViewController {
    private let network: ThirdPartyDemandNetwork
    
    deinit {
        Nimbus.shared.extensions.removeAll(where: { $0 is SweepingExtension })
    }
    
    init(network: ThirdPartyDemandNetwork, headerTitle: String, headerSubTitle: String) {
        self.network = network
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Nimbus.shared.extensions.append(SweepingExtension(keep: network))
    }
}
