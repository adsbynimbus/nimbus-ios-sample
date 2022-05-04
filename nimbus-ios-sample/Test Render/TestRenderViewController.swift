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
    
    private lazy var markupTexField: UITextField = {
        let textField = UITextField()
        textField.textColor = .turquoise
        textField.tintColor = .turquoise
        textField.font = .proximaNova(size: 15, weight: .regular)
        textField.autocorrectionType = .no
        textField.contentVerticalAlignment = .top
        textField.clearButtonMode = .always
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.accessibilityIdentifier = "testRenderMarkupTextField"
        
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
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
        
        setupTextField()
        setupTestButton()
    }
    
    private func setupTextField() {
        view.addSubview(markupTexField)
        
        markupTexField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markupTexField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            markupTexField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            markupTexField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTestButton() {
        view.addSubview(testButton)
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.topAnchor.constraint(equalTo: markupTexField.bottomAnchor, constant: 30),
            testButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45),
            testButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            testButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func testButtonTapped() {
        guard let adMarkup = markupTexField.text, !adMarkup.isEmpty else { return }
        
        navigationController?.pushViewController(
            TestRenderAdViewController(adMarkup: adMarkup),
            animated: true
        )
    }
}

extension TestRenderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
