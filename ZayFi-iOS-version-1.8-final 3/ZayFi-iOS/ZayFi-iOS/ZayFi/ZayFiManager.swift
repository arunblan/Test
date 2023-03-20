//
//  ZayFiManager.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 14/10/21.
//

import Foundation

class ZayFiManager: NSObject {
    let user: ZFUser
    var isAutoLoginStatusChecked: Bool = false
    
    // MARK: - Initialization
    private static var sharedMManager: ZayFiManager = {
        let mapManager = ZayFiManager()
        return mapManager
    }()
    private override init() {
        user = ZFUser()
        super.init()
        getLocalUser()
    }
    
    private func getLocalUser() {
        user.userID = ZFDefault.getDataFromDefault(.userID) as? Int32
        user.name = ZFDefault.getDataFromDefault(.name) as? String
        user.email = ZFDefault.getDataFromDefault(.email) as? String
        user.phoneNumber = ZFDefault.getDataFromDefault(.phoneNumber) as? String
        user.passwordHash = ZFDefault.getDataFromDefault(.passwordHash) as? String
    }
    
    func updateUserInfo(_ info: ZFUserData?) {
        if let userInfo = info {
            ZFDefault.setDataToDefault(value: userInfo.userID as Any, .userID)
            ZFDefault.setDataToDefault(value: userInfo.email as Any, .email)
            ZFDefault.setDataToDefault(value: userInfo.name as Any, .name)
            ZFDefault.setDataToDefault(value: userInfo.mobile as Any, .phoneNumber)
            ZFDefault.setDataToDefault(value: userInfo.passwordHash as Any, .passwordHash)
        } else {
            ZFDefault.removeDataFromDefault(.userID)
            ZFDefault.removeDataFromDefault(.email)
            ZFDefault.removeDataFromDefault(.name)
            ZFDefault.removeDataFromDefault(.phoneNumber)
            ZFDefault.removeDataFromDefault(.passwordHash)
        }
        getLocalUser()
    }
    
    func updateUserInfoNew(_ info: ZFUserData?) {
        if let userInfo = info {
            
            ZFDefault.setDataToDefault(value: userInfo.mobile as Any, .phoneNumber)
            
            
            if userInfo.userID != nil {
                ZFDefault.setDataToDefault(value: userInfo.userID as Any, .userID)
            }
            if userInfo.email != nil {
                ZFDefault.setDataToDefault(value: userInfo.email as Any, .email)
            }
            if userInfo.name != nil {
                ZFDefault.setDataToDefault(value: userInfo.name as Any, .name)
            }
            
            
            if userInfo.passwordHash != nil {
                ZFDefault.setDataToDefault(value: userInfo.passwordHash as Any, .passwordHash)
            }
            
            if userInfo.passwordHash != nil {
                ZFDefault.setDataToDefault(value: userInfo.passwordHash as Any, .passwordHash)
            }
            
            if userInfo.passwordHash != nil {
                ZFDefault.setDataToDefault(value: userInfo.userName as Any, .userName)
            }
            
        } else {
            ZFDefault.removeDataFromDefault(.userID)
            ZFDefault.removeDataFromDefault(.email)
            ZFDefault.removeDataFromDefault(.name)
            ZFDefault.removeDataFromDefault(.phoneNumber)
            ZFDefault.removeDataFromDefault(.passwordHash)
        }
        getLocalUser()
    }
    

    
    /**
     func sharedInstance:
      - Returns: ZayFi  signleton object
     */
    @objc public class func sharedInstance() -> ZayFiManager {
        return sharedMManager
    }
    
    
    
}
