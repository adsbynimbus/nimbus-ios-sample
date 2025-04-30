//
//  TestRenderViewController.swift
//  nimbus-ios-sample
//
//  Created on 22/11/21.
//

import UIKit
import NimbusKit

class TestRenderViewController: DemoViewController {
    
    var isBlocking = false
    
    private var iTunesAppId: String?
    
    private lazy var skoverlayMenuButton: UIButton = {
        let closure: (UIAction) -> () = { [weak self] (action: UIAction) in
            self?.iTunesAppId = switch action.identifier.rawValue {
            case "timehop": "569077959"
            case "yelp": "284910350"
            case "ig": "389801252"
            case "tinder": "547702041"
            case "imgur": "639881495"
            default: nil
            }
        }
        
        let button = UIButton(type: .system)
        button.menu = UIMenu(title: "", children: [
            UIAction(title: "SKOverlay: None", identifier: .init("none"), handler: closure),
            UIAction(title: "SKOverlay: Timehop", identifier: .init("timehop"), handler: closure),
            UIAction(title: "SKOverlay: Yelp", identifier: .init("yelp"), handler: closure),
            UIAction(title: "SKOverlay: Instagram", identifier: .init("ig"), handler: closure),
            UIAction(title: "SKOverlay: Tinder", identifier: .init("tinder"), handler: closure),
            UIAction(title: "SKOverlay: Imgur", identifier: .init("imgur"), handler: closure),
        ])
        
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        return button
    }()
    
    private lazy var markupTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .turquoise
        textView.tintColor = .turquoise
        textView.font = .proximaNova(size: 15, weight: .regular)
        textView.autocorrectionType = .no
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.accessibilityIdentifier = "markup_text"
        
        let accessoryView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        accessoryView.axis = .vertical
        accessoryView.alignment = .center
        
        // Clear text button
        var clearTextBtnConfig = UIButton.Configuration.bordered()
        clearTextBtnConfig.background = UIBackgroundConfiguration.clear()
        clearTextBtnConfig.background.cornerRadius = 5
        clearTextBtnConfig.background.backgroundColor = .systemGray5
        clearTextBtnConfig.title = "Clear"
        clearTextBtnConfig.image = UIImage(systemName: "clear")
        clearTextBtnConfig.imagePadding = 10
        
        let clearTextBtn = UIButton(configuration: clearTextBtnConfig)
        clearTextBtn.addTarget(self, action: #selector(didTapOnClearText), for: .touchUpInside)
        
        // Render button
        var renderBtnConfig = UIButton.Configuration.bordered()
        renderBtnConfig.background = UIBackgroundConfiguration.clear()
        renderBtnConfig.background.cornerRadius = 5
        renderBtnConfig.background.backgroundColor = .systemGray5
        renderBtnConfig.title = "Render"
        renderBtnConfig.image = UIImage(systemName: "play")
        renderBtnConfig.imagePadding = 10
        
        let renderBtn = UIButton(configuration: renderBtnConfig)
        renderBtn.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
        
        let contentView = UIStackView(arrangedSubviews: [clearTextBtn, renderBtn])
        contentView.axis = .horizontal
        contentView.alignment = .center
        contentView.spacing = 16
        
        accessoryView.addArrangedSubview(contentView)
        
        textView.inputAccessoryView = accessoryView
        return textView
    }()
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("Test".uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .proximaNova(size: 20, weight: .bold)
        button.backgroundColor = .pink
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
        return button
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setupSKOverlayPopup()
        setupTextView()
        setupTestButton()
    }
    
    private func setupSKOverlayPopup() {
        view.addSubview(skoverlayMenuButton)
        
        skoverlayMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skoverlayMenuButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            skoverlayMenuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            skoverlayMenuButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            skoverlayMenuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTextView() {
        view.addSubview(markupTextView)
        
        markupTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markupTextView.topAnchor.constraint(equalTo: skoverlayMenuButton.bottomAnchor, constant: 16),
            markupTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            markupTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTestButton() {
        view.addSubview(testButton)
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.topAnchor.constraint(equalTo: markupTextView.bottomAnchor, constant: 30),
            testButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45),
            testButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            testButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func didTapOnClearText() {
        markupTextView.text = nil
    }
    
    @objc private func testButtonTapped() {
        guard let adMarkup = markupTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                !adMarkup.isEmpty else {
            let alertVC = UIAlertController(
                title: "Invalid Ad",
                message: "Please enter a valid HTML or VAST ad.",
                preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertVC, animated: true)
            return
        }
        
        markupTextView.resignFirstResponder()
        
        let ad = getAdFromMarkup(adMarkup: adMarkup)
        
        if isBlocking {
            TestRenderAdViewController.showBlocking(from: self, ad: ad)?.start()
        } else {
            navigationController?.pushViewController(
                TestRenderAdViewController(ad: ad),
                animated: true
            )
        }
    }
                                       
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            markupTextView.contentInset = .zero
        } else {
            // Calculating the difference between the textView's bottom and view bottom as the keyboard size covers just a part of the textView
            let bottomOffset = view.bounds.height - (markupTextView.frame.origin.y + markupTextView.frame.size.height)
            markupTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - bottomOffset, right: 0)
        }

        markupTextView.scrollIndicatorInsets = markupTextView.contentInset

        let selectedRange = markupTextView.selectedRange
        markupTextView.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: - Create NimbusAd
    
    private func getAdFromMarkup(adMarkup: String) -> NimbusAd {
        let type: NimbusAuctionType = isVideoMarkup(adMarkup: adMarkup) ? .video : .static
        return createNimbusAd(auctionType: type, markup: adMarkup)
    }
    
    private func isVideoMarkup(adMarkup: String) -> Bool {
        let prefix = adMarkup.prefix(5).lowercased()
        return prefix == "<vast" || prefix == "<?xml"
    }
    
    private func createNimbusAd(
        placementId: String? = nil,
        auctionType: NimbusAuctionType,
        markup: String,
        isMraid: Bool = true,
        isInterstitial: Bool = true
    ) -> NimbusAd {
        let adDimensions = isInterstitial ?
        NimbusAdDimensions(width: 320, height: 480) :
        NimbusAdDimensions(width: 300, height: 50)
        
        let ext = NimbusAdExtensions(
            skAdNetwork: iTunesAppId != nil ? NimbusAdSkAdNetwork(advertisedAppStoreItemID: iTunesAppId) : nil
        )
        
        return NimbusAd(
            position: "",
            auctionType: auctionType,
            bidRaw: 0,
            bidInCents: 0,
            contentType: "",
            auctionId: "",
            network: "test_render",
            markup: markup,
            isInterstitial: isInterstitial,
            placementId: nil,
            duration: nil,
            adDimensions: adDimensions,
            trackers: nil,
            isMraid: isMraid,
            extensions: ext
        )
    }
}
