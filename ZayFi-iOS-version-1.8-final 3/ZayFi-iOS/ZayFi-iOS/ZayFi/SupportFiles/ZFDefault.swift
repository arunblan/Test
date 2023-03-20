//
//  BEDefault.swift
//  beCoMap_GlobalVillage
//
//  Created by Rinoy Francis on 17/09/20.
//  Copyright © 2020 GlobeCo Technologies Pvt Ltd. All rights reserved.
//

import Foundation

class ZFDefault {
    
    static private let prefs = UserDefaults.standard
    
    //MARK: Save point Data
    /**
     - usage: BEDefault.setDataToDefault(value: [["id" : 1219, "name" : "blanket"]],UserDefaultsKeys.pointHistory)
     */
    class func setDataToDefault(value: Any, _ userDefaultsKeys: UserDefaultsKeys) {
        prefs.set(value, forKey: userDefaultsKeys.rawValue)
        prefs.synchronize()
    }
    
    //MARK: Retrieve point Data
    class func getDataFromDefault(_ userDefaultsKeys: UserDefaultsKeys) -> Any {
        if (prefs.object(forKey: userDefaultsKeys.rawValue) != nil)  {
            return prefs.object(forKey: userDefaultsKeys.rawValue)!
        } else {
            return ""
        }
    }
    
    //MARK: Remove point Data
    /**
     - usage: BEDefault.removeDataFromDefault(UserDefaultsKeys.pointHistory)
     */
    class func removeDataFromDefault(_ userDefaultsKeys: UserDefaultsKeys) {
        return prefs.removeObject(forKey: userDefaultsKeys.rawValue)
    }
    
}


enum UserDefaultsKeys : String {
    case userID
    case email
    case name
    case phoneNumber
    case passwordHash
    case pushToken
    case isDebugMode
    case showCampaign
    case sessionID
    case dataUsage
    case isAuthenticate
    case userName
}
