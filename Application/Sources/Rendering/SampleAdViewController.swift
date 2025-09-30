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
import NimbusKit

class SampleAdViewController : DemoViewController {
    
    let screenLogger = SampleAppLogger()
    weak var loggerView: UIView?
    
    private let enabledState = ExtensionHelper.enabledState
    
    deinit {
        ExtensionHelper.restoreExtensionsState(from: enabledState)
    }
    
    init(headerTitle: String, headerSubTitle: String, enabledExtension: NimbusExtension.Type?) {
        super.init(headerTitle: headerTitle, headerSubTitle: headerSubTitle)
        
        ExtensionHelper.disableAllExtensions(except: enabledExtension)
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
    
    func didReceiveNimbusEvent(event: NimbusEvent, ad: Ad? = nil) {
        if let response = ad?.response, event == .loaded {
            screenLogger.logRender(response)
        }
        screenLogger.logEvent(event)
    }
    
    func didReceiveNimbusError(error: NimbusError) {
        screenLogger.logError(error)
    }
    
    @objc private func didTapOnLogger() {
        loggerView?.isHidden.toggle()
    }
}
