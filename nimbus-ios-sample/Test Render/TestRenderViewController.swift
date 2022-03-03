//
//  TestRenderViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 22/11/21.
//

import UIKit

class TestRenderViewController: DemoViewController {
    override var headerTitle: String {
        "Test Render"
    }
    
    override var headerSubTitle: String {
        "Paste in a VAST or HTML Nimbus response"
    }
    
    private lazy var markupTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .turquoise
        textView.tintColor = .turquoise
        textView.font = .proximaNova(size: 15, weight: .regular)
        textView.autocorrectionType = .no
        textView.contentInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.accessibilityIdentifier = "testRenderMarkupTextView"
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
        button.accessibilityIdentifier = "testRenderTestButton"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc private func testButtonTapped() {
        navigationController?.pushViewController(
            TestRenderAdViewController(adMarkup: markupTextView.text),
            animated: true
        )
    }
}
