import Foundation
import  UIKit

/**
 BEExtras
 - Version: 1.0
 - Copyright: Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
 */
class ZFExtras {
    
    class var bundleIdentifier: String { return Bundle.main.bundleIdentifier ?? "" }
    class var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    class var systemVersion: String { return UIDevice.current.systemVersion }
    class var appVersion: String { return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "" }
    class var appBuildVersion: String { return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "" }
    class var sdkVersion: String { return ZFExtras.getBundle()?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "" }
    class var sdkBuildVersion: String { return ZFExtras.getBundle()?.infoDictionary?["CFBundleVersion"] as? String ?? "" }
    class var deviceID: String {
        #if targetEnvironment(simulator)
        return "00000000-0000-0000-0000-000000000000"
        #else
        let device: UIDevice = UIDevice.current
        return (device.identifierForVendor?.uuidString)!
        #endif
    }
    class var userAgent: String {
        return "\(bundleIdentifier)/\(appVersion)-\(appBuildVersion) \(HTTP_HEADER_VALUE_IPHONE) iOS/\(systemVersion) ZayFi/\(sdkVersion)-\(sdkBuildVersion)"
    }
    
    class func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func getBundle() -> Bundle? {
        return Bundle(for: self)//Bundle(identifier: "com.beCo.beCoMap")
    }
    
    class func getImage(named imageName: String) -> UIImage? {
        if let image = UIImage(named: imageName, in: getBundle(), compatibleWith: nil) {
            return image
        }
        return UIImage(named: imageName, in: getBundle(), compatibleWith: nil)
    }
    
    class func getColor(named colorName: String) -> UIColor {
        return UIColor(named: colorName, in: getBundle(), compatibleWith: nil)!
    }

    
    class func imageFromView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    class func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return text.filter {okayChars.contains($0) }
    }
    
    class func isValidPhone(_ number: String) -> Bool {
        let phoneRegEx = "^((\\+)|(00))[0-9]{6,14}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: number)
    }
    
    class func isValidEmail(_ email: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    class func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
