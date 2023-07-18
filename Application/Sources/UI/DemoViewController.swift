//
//  DemoViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import NimbusKit
import UIKit

class DemoViewController: UIViewController {
    static let headerOffset: CGFloat = 16
    
    private(set) var headerTitle: String = ""
    private(set) var headerSubTitle: String = ""
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 20, weight: .bold)
        label.text = headerTitle
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 15)
        label.text = headerSubTitle
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    lazy var headerView: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = .raisingBlack
        
        let contentView = UIStackView()
        contentView.axis = .vertical
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: header.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -15),
            contentView.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -20),
        ])
        
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(subTitleLabel)
        
        return header
    }()
    
    private var headerHeightConstraint: NSLayoutConstraint!
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(headerTitle: String, headerSubTitle: String) {
        self.headerTitle = headerTitle
        self.headerSubTitle = headerSubTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(didTapOnInfo))]
        
        view.backgroundColor = .systemBackground
        
        view.layout(headerView) { child in
            child.alignTop()
            child.fill(.width, safeLayoutGuide: false)
        }
        
        headerHeightConstraint = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        view.addConstraint(headerHeightConstraint)
        
        setupLogo()
    }
    
    func setupScrollView(_ tableView: UIScrollView) {
        view.layout(tableView) { child in
            child.below(headerView)
            child.fill()
        }
    }
    
    @objc private func didTapOnInfo() {
        UIView.animate(withDuration: 0.2) {
            self.headerHeightConstraint.constant = self.headerHeightConstraint.constant == 0 ? 80 : 0
            self.view.layoutIfNeeded()
        }
    }
}

protocol HasAnchors {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: HasAnchors {}
extension UILayoutGuide: HasAnchors {}

extension UIView {
    @resultBuilder
    struct LayoutBuilder {
        static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
            return components.flatMap { $0 }
        }
    }
    
    enum Fill {
        case width, height, both
    }
    
    struct ConstraintBuilder {
        let parent: UIView
        let child: UIView
        
        func alignTop() -> [NSLayoutConstraint] {
            [child.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor)]
        }
        
        func below(_ view: UIView) -> [NSLayoutConstraint] {
            [child.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        }
        
        func fill(_ fill: Fill = .both, safeLayoutGuide: Bool = true) -> [NSLayoutConstraint] {
            let attached: HasAnchors = safeLayoutGuide ? self.parent.safeAreaLayoutGuide : self.parent
            
            switch(fill) {
            case .width:
                return [child.leadingAnchor.constraint(equalTo: attached.leadingAnchor),
                 child.trailingAnchor.constraint(equalTo: attached.trailingAnchor)]
            case .height:
                return [child.bottomAnchor.constraint(equalTo: attached.bottomAnchor)]
            case .both:
                return [
                    child.leadingAnchor.constraint(equalTo: attached.leadingAnchor),
                    child.trailingAnchor.constraint(equalTo: attached.trailingAnchor),
                    child.bottomAnchor.constraint(equalTo: attached.bottomAnchor)
                ]
            }
        }
        
        func height(_ height: CGFloat) -> [NSLayoutConstraint] {
            [child.heightAnchor.constraint(equalToConstant: height)]
        }
    }
    
    func layout(_ view: UIView, @LayoutBuilder constraints: (ConstraintBuilder) -> [NSLayoutConstraint]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = constraints(ConstraintBuilder(parent: self, child: view))
        NSLayoutConstraint.activate(constraints)
    }
}
