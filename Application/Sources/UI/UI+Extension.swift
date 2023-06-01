//
//  UI+Extension.swift
//  nimbus-ios-sample
//
//  Created by Jason Sznol on 5/28/23.
//

import SwiftUI
import UIKit

extension NSObject {
    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension Alert {
    public static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                NSLog("OK was selected")
            }
            alertController.addAction(okAction)
            
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let firstWindow = firstScene.windows.first,
                  let viewController = firstWindow.rootViewController else {
                return
            }
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UIColor {
    static var pink = UIColor(named: "pink")!
    static var raisingBlack = UIColor(named: "raisinBlack")!
    static var turquoise = UIColor(named: "turquoise")!
}

enum ProximaNovaWeight: String {
    case bold, regular, semibold
}

extension UIFont {

    static func proximaNova(size: CGFloat, weight: ProximaNovaWeight = .regular) -> UIFont {
        let name = "ProximaNova-\(weight.rawValue.capitalized)"
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Font '\(name)' not found")
        }
        return font
    }
}

extension Font {
    static func proximaNova(size: CGFloat, weight: ProximaNovaWeight = .regular) -> Font {
        Font.custom("ProximaNova-\(weight.rawValue.capitalized)", size: size)
    }
}

extension UIImage {
    func imageWithInset(inset: CGFloat) -> UIImage {
        imageWithInsets(
            insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        )
    }
    
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(
                width: size.width + insets.left + insets.right,
                height: size.height + insets.top + insets.bottom
            ), false,
            scale
        )
        let origin = CGPoint(x: insets.left, y: insets.top)
        draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
}

extension UILabel {
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(
                NSAttributedString.Key.kern,
                value: value,
                range: NSRange(location: 0, length: attributedString.length - 1)
            )
            attributedText = attributedString
        }
    }
}

extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: T.nameOfClass)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: T.nameOfClass)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.nameOfClass, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.nameOfClass)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.nameOfClass) as? T else {
            fatalError("Could not dequeue header with identifier: \(T.nameOfClass)")
        }
        return header
    }
}

extension UIViewController {
    func setupLogo() {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 145 * 0.8, height: 50 * 0.8)
        navigationItem.titleView = imageView
    }
    
    func showCustomAlert(_ missingKey: String) {
        let alert = UIAlertController(
            title: "Attention",
            message: "\(missingKey) is missing or not set in Keys.xcconfig",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
