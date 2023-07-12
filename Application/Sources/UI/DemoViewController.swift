//
//  DemoViewController.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 09/11/21.
//

import NimbusKit
import UIKit

class DemoViewController: UIViewController {
    private(set) var headerTitle: String = ""
    private(set) var headerSubTitle: String = ""
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 20, weight: .bold)
        label.text = headerTitle
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .raisingBlack
        
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .proximaNova(size: 15)
        label.text = headerSubTitle
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .raisingBlack
        
        return label
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .raisingBlack
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -20),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        return view
    }()
        
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
        
        view.backgroundColor = .systemBackground
        
        view.layout(headerView) { child in
            child.alignTop()
            child.fill(.width, safeLayoutGuide: false)
            child.height(80)
        }
        setupLogo()
    }
    
    func setupScrollView(_ tableView: UIScrollView) {
        view.layout(tableView) { child in
            child.below(headerView)
            child.fill()
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
