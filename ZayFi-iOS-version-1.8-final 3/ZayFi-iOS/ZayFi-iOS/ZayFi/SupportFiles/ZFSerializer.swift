import Foundation

/**
 BESerializer
 - Version: 1.0
 - Copyright: Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
 */
class ZFSerializer {
    
    class func convertToData(from params: [String: Any]) -> Data? {
        do {
            print("params : \(params)")
            return try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch {
            return nil
        }
    }
    
    class func convertToDictionary(from data: Data?) -> NSDictionary {
        guard data != nil else {
            return [:]
        }
        do {
            let temp = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let tempDict = temp as? NSDictionary {
                return tempDict
            } else {
                return [:]
            }
        } catch let error {
            ZFLog.debugLog("Object serialization failed: \(error)")
            return [:]
        }
    }
    
    // T is Swift Generics used as a Placeholder type so that its compiled in runtime.
    class func serialize<T : Codable>(modalType: T.Type, data: Data) -> Any?{
        do {
            return try JSONDecoder().decode(modalType, from: data) as Any
        } catch {
            ZFLog.debugLog("Object serialization failed")
            return nil
        }
    }
}
