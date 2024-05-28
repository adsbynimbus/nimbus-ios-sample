//
//  TestRenderViewController.swift
//  nimbus-ios-sample
//
//  Created on 22/11/21.
//

import UIKit

class TestRenderViewController: DemoViewController {
    
    var isBlocking = false
    
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
        
        setupTextView()
        setupTestButton()
    }
    
    private func setupTextView() {
        view.addSubview(markupTextView)
        
        markupTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markupTextView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
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
        
        if isBlocking {
            TestRenderAdViewController.showBlocking(from: self, adMarkup: adMarkup)
        } else {
            navigationController?.pushViewController(
                TestRenderAdViewController(adMarkup: adMarkup),
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
}
