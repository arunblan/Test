//
//  BeCoExtentions.swift
//  BeCoMap-iOS-SDK
//
//  Created by Mithin Thomas on 16/05/19.
//  Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
//

import CoreLocation
import UIKit

//extension UIView {
//    
//    var safeTopAnchor: NSLayoutYAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return safeAreaLayoutGuide.topAnchor
//        }
//        return topAnchor
//    }
//    
//    var safeLeftAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *){
//            return safeAreaLayoutGuide.leftAnchor
//        }
//        return leftAnchor
//    }
//    
//    var safeRightAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *){
//            return safeAreaLayoutGuide.rightAnchor
//        }
//        return rightAnchor
//    }
//    
//    var safeBottomAnchor: NSLayoutYAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return safeAreaLayoutGuide.bottomAnchor
//        }
//        return bottomAnchor
//    }
//    
//    var safeLeadingAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return safeAreaLayoutGuide.leadingAnchor
//        }
//        return leadingAnchor
//    }
//    
//    var safeTrailingAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return safeAreaLayoutGuide.trailingAnchor
//        }
//        return trailingAnchor
//    }
//}

@IBDesignable
extension UIView {

    @IBInspectable
    var borderRadius: CGFloat {
        set (radius) {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = radius > 0
        }
        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        set (borderWidth) {
            self.layer.borderWidth = borderWidth
        }
        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable
    var borderColor:UIColor? {
        set (color) {
            self.layer.borderColor = color?.cgColor
        }
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
}

extension UIViewController {
    func showValidationError(message: String, completionHandler: @escaping (_ proceed: Bool) -> Void) {
        guard let nav = navigationController, let top = nav.topViewController else {
            return
        }
        let appName = Bundle.main.displayName
        let alert = UIAlertController(title: appName, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "zf_redtextcolour");
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (UIAlertAction)in
            alert.dismiss(animated: true)
            completionHandler(true)
        }))
        DispatchQueue.main.async {
            top.present(alert, animated: true, completion: nil)
        }
    }
}

extension Array where Element: Hashable {
    func nextElementAfterFirstMatch(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 < self.count {
            return self[index + 1]
        }
        return nil
    }
    func previousElementAfterFirstMatch(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index > 0 {
            return self[index - 1]
        }
        return nil
    }
    mutating func removeConsecutiveDuplicates() {
        var result = [Element]()
        for (index,value) in self.enumerated() {
            if index == 0 {
                result.append(value)
            } else if value != self[index-1] {
                result.append(value)
            }
        }
        self = result
    }
    
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

extension Bundle {
    // Name of the app - title under the icon.
    var displayName: String? {
            return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
