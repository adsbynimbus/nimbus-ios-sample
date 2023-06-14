//
//  SampleAdViewController.swift
//  NimbusInternalSampleApp
//
//  Created by Jason Sznol on 6/1/23.
//  Copyright © 2023 Timehop. All rights reserved.
//

import NimbusRenderKit
import SwiftUI
import UIKit

class SampleAdViewController : DemoViewController, AdControllerDelegate {
    
    let screenLogger = Logger()
    weak var loggerView: UIView?
    var nimbusAd: NimbusAd? = nil
    
    override init(headerTitle: String, headerSubTitle: String) {
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let logView = loggerView {
            view.sendSubviewToBack(logView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: ScreenLogger().environmentObject(screenLogger))
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(childView)
        view.addSubview(childView.view)
    
        NSLayoutConstraint.activate([
            childView.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            childView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            childView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            childView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        childView.didMove(toParent: self)
        loggerView = childView.view
    }
    
    func didReceiveNimbusEvent(controller: AdController, event: NimbusEvent) {
        if let ad = nimbusAd, event == .loaded {
            screenLogger.logRender(ad)
        }
        screenLogger.logEvent(event)
    }
    
    func didReceiveNimbusError(controller: AdController, error: NimbusError) {
        screenLogger.logError(error)
    }
}