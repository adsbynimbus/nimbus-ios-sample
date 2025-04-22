//
//  SampleAdViewController.swift
//  NimbusInternalSampleApp
//
//  Created on 6/1/23.
//  Copyright © 2023 Nimbus Advertising Solutions Inc. All rights reserved.
//

import NimbusRenderKit
import SwiftUI
import UIKit

class SampleAdViewController : DemoViewController, AdControllerDelegate {
    
    let screenLogger = SampleAppLogger()
    weak var loggerView: UIView?
    var nimbusAd: NimbusAd? = nil
    
    private let enabledState = Nimbus.shared.extensions.mapValues { $0.enabled }
    
    deinit {
        restoreExtensionsState(from: enabledState)
    }
    
    init(headerTitle: String, headerSubTitle: String, enabledExtension: NimbusExtension.Type?) {
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
        
        disableAllExtensions(except: enabledExtension)
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
        
        view.backgroundColor = .white
        
        let childView = UIHostingController(rootView: ScreenLogger().environmentObject(screenLogger))
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(childView)
        view.addSubview(childView.view)
    
        NSLayoutConstraint.activate([
            childView.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            childView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            childView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        childView.didMove(toParent: self)
        loggerView = childView.view
        loggerView?.isHidden = UserDefaults.standard.eventLogHiddenByDefault
        
        var rightItems = navigationItem.rightBarButtonItems ?? []
        
        let loggerButton = UIBarButtonItem(
            image: UIImage(systemName: "t.bubble"),
            style: .plain,
            target: self,
            action: #selector(didTapOnLogger)
        )
        loggerButton.accessibilityIdentifier = "nimbus_event_log_button"
        rightItems.append(loggerButton)
        
        navigationItem.rightBarButtonItems = rightItems
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
    
    @objc private func didTapOnLogger() {
        loggerView?.isHidden.toggle()
    }
    
    func disableAllExtensions(except: NimbusExtension.Type? = nil) {
        for (key, ext) in Nimbus.shared.extensions {
            if except == nil || key != ObjectIdentifier(except!) {
                ext.disable()
            }
        }
    }
    
    func restoreExtensionsState(from: [ObjectIdentifier: Bool]) {
        for (extType, enabled) in from {
            guard let ext = Nimbus.shared.extensions[extType] else {
                continue
            }
            
            if enabled && !ext.enabled { ext.enable() }
            else if !enabled && ext.enabled { ext.disable() }
        }
    }
}
