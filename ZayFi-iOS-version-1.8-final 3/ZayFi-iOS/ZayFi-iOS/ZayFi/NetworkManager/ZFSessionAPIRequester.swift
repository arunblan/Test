//
//  BESessionAPIRequester.swift
//  BeCoMap-iOS-SDK
//
//  Created by Mithin Thomas on 06/06/19.
//  Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
//

import Foundation

enum ZFSessionAPIActionType: Int {
    case GetConfig
    case Register
    case CheckStatus
    case UserLogin
    case UpdateUser
    case ResetPassword
    case RegisterPush
    case SessionInfo
    case RouterLogin1
    case RouterLogin2
    case Terminate
    case Logout
    case Register_New
    case ValidateOtp
    case GetOTPLogin
    case loginNew
    case AutoLogin
    
    
};

/**
 BESDKAPIRequester
 - Version: 1.0
 - Copyright: Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
 */
final class BESessionAPIRequester: ZFAPIRequester {
    
    var actionType: ZFSessionAPIActionType?
    
    var secretResponse: String?
    var password: String?
    var email: String?
    var mobileNumber: String?

        
    override var httPMethod: ZFHTTPMethod {
        switch actionType {
        case .loginNew?:
            return .HTTPPOSTMethod
        case .GetOTPLogin?:
            return .HTTPPOSTMethod
        case .ValidateOtp?:
            return .HTTPPOSTMethod
        case .Register_New?:
            return .HTTPPOSTMethod
        case .GetConfig?:
            return .HTTPGETMethod
        case .Register?:
            return .HTTPPOSTMethod
        case .CheckStatus?:
            return .HTTPGETMethod
        case .UserLogin?:
            return .HTTPPOSTMethod
        case .ResetPassword?:
            return .HTTPPOSTMethod
        case .RegisterPush?:
            return .HTTPPOSTMethod
        case .UpdateUser?:
            return .HTTPPOSTMethod
        case .SessionInfo?:
            return .HTTPPOSTMethod
        case .RouterLogin1?:
            return .HTTPPOSTMethod
        case .RouterLogin2?:
            return .HTTPGETMethod
        case .AutoLogin?:
            return .HTTPPOSTMethod
        case .Terminate?:
            return .HTTPPOSTMethod
        case .Logout?:
            return .HTTPGETMethod
        default:
            return .HTTPGETMethod
        }
    }
    
    override var url: URL {
        switch actionType {
        case .AutoLogin?:
            return URL(string: "https://api.zayfi.com/api/user/wifi/app-auto-login")!
        case .loginNew?:
            return URL(string: "https://api.zayfi.com/api/user/wifi/v2/verify-otp")!
        case .GetOTPLogin?:
            return URL(string: "https://api.zayfi.com/api/user/wifi/v2/register")!
        case .ValidateOtp?:
            return URL(string: "https://api.zayfi.com/api/user/wifi/v2/verify-otp")!
        case .Register_New?:
            return URL(string: "https://api.zayfi.com/api/user/wifi/v2/register")!
        case .GetConfig?:
            return URL(string: "https://zayfi.s3.ap-south-1.amazonaws.com/version.json")!
        case .Register?:
            return URL(string: ZFURLapiRegister)!
        case .CheckStatus?:
            return URL(string: ZFURLapiStatus)!
        case .UserLogin?:
            return URL(string: ZFURLapiUserLogin)!
        case .ResetPassword?:
            return URL(string: ZFURLapiUserResetPassowrd)!
        case .RegisterPush?:
            return URL(string: ZFURLapiRegisterPush)!
        case .UpdateUser?:
            return URL(string: ZFURLapiUpdateUser)!
        case .SessionInfo?:
            return URL(string: ZFURLapiSessionInfo)!
        case .RouterLogin1?:
            return URL(string: ZFURRouterLogin1)!
        case .RouterLogin2?:
            //http://172.22.100.1:3990/json/logon?username=hello5&response=060f922d621728c5d27148a6bcfc940b
            return URL(string: "\(ZFURRouterLogin2)?username=\(user?.phoneNumber ?? "")&response=\(secretResponse ?? "")")!
        case .Terminate?:
            return URL(string: ZFURLapiSessionTerminate)!
        case .Logout?:
            return URL(string: ZFURLapiLogout)!
        case .none:
            return  URL(string: ZFURLapiServicesRadiusdeskEndpoint)!
        }
    }
    
    override var contentType: String {
        return "application/json"
    }
    
    override var acceptType: String {
        return "application/json"
    }
    
    override var postData: Data? {
        switch actionType {
        case .AutoLogin?:
            var postData: [String : Any] = [:]
            postData["network_group"] = 1
//            postData["username"] = ZayFiManager.sharedInstance().user.userSession?.routerSession?.userName ?? ""
            postData["session_id"] = ZayFiManager.sharedInstance().user.userSession?.routerSession?.sessionId ?? ""
//            postData["mac"] = ZayFiManager.sharedInstance().user.userSession?.redir?.macAddress ?? ""
            return ZFSerializer.convertToData(from: postData)
        case .loginNew?:
            var postData: [String : Any] = [:]
            postData["network_group"] = 1
            postData["mobile"] = user?.phoneNumber
            postData["otp"] = user?.otpNumber
            postData["id"] = ""
            return ZFSerializer.convertToData(from: postData)
        case .GetOTPLogin?:
            var postData: [String : Any] = [:]
            postData["network_group"] = 1
            postData["mobile"] = user?.phoneNumber
            return ZFSerializer.convertToData(from: postData)
        case .ValidateOtp?:
            var postData: [String : Any] = [:]
            postData["network_group"] = 1
            postData["mobile"] = user?.phoneNumber
            postData["otp"] = user?.otpNumber
            postData["id"] = ZFDefault.getDataFromDefault(.userID) as? Int32 ?? ""
            return ZFSerializer.convertToData(from: postData)
        case .Register_New?:
            var postData: [String : Any] = [:]
            postData["network_group"] = 1
            postData["email"] = user?.email
            postData["mobile"] = user?.phoneNumber
            postData["name"] = ""
            return ZFSerializer.convertToData(from: postData)
        case .Register?:
            var postData: [String : Any] = [:]
            postData["email"] = user?.email
            postData["username"] = user?.phoneNumber
            postData["name"] = user?.name
            postData["mobile"] = user?.phoneNumber
            postData["password"] = password
            postData["password_confirmation"] = password
            postData["network_group"] = 1
            return ZFSerializer.convertToData(from: postData)
        case .UserLogin?:
            var postData: [String : Any] = [:]
            postData["username"] = user?.phoneNumber
            postData["password"] = password
            postData["network_group"] = 1
            return ZFSerializer.convertToData(from: postData)
        case .ResetPassword?:
            var postData: [String : Any] = [:]
            postData["username"] = user?.phoneNumber
            postData["email"] = user?.email
            return ZFSerializer.convertToData(from: postData)
        case .RegisterPush?:
            var postData: [String : Any] = [:]
            postData["username"] = user?.phoneNumber
            postData["user_id"] = user?.userID
            postData["device_token"] = ZFDefault.getDataFromDefault(.pushToken) as? String ?? ""
            postData["device_type"] = "IOS"
            return ZFSerializer.convertToData(from: postData)
        case .UpdateUser?:
            var postData: [String : Any] = [:]
            postData["email"] = user?.email
            postData["username"] = user?.phoneNumber
            postData["name"] = user?.name
            postData["mobile"] = user?.phoneNumber
            postData["network_group"] = 1
            postData["password_hash"] = ZayFiManager.sharedInstance().user.passwordHash
            return ZFSerializer.convertToData(from: postData)
        case .SessionInfo?:
            var postData: [String : Any] = [:]
            postData["username"] = user?.phoneNumber
            postData["password_hash"] = ZayFiManager.sharedInstance().user.passwordHash
            postData["network_group"] = 1
            postData["session_id"] = ZayFiManager.sharedInstance().user.userSession?.routerSession?.sessionId ?? ""
            return ZFSerializer.convertToData(from: postData)
        case .RouterLogin1?:
            var postData: [String : Any] = [:]
            postData["username"] = user?.phoneNumber
            postData["password"] = user?.passwordHash
            postData["challenge"] = user?.userSession?.challenge
            postData["nasid"] = user?.userSession?.nasid
            postData["network_group"] = 1
            return ZFSerializer.convertToData(from: postData)
        case .Terminate?:
            var postData: [String : Any] = [:]
            postData["username"] = user?.phoneNumber
            postData["password_hash"] = ZayFiManager.sharedInstance().user.passwordHash
            postData["network_group"] = 1
            postData["session_id"] = ZayFiManager.sharedInstance().user.userSession?.routerSession?.sessionId ?? ""
            return ZFSerializer.convertToData(from: postData)
        default:
            return nil
        }
    }
    
    override func handleResponseData(responseData: Data) -> Any? {
        switch actionType {
        case .AutoLogin?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .loginNew?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .GetOTPLogin?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .ValidateOtp?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .Register_New?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .GetConfig?:
            return ZFSerializer.serialize(modalType: ZFConfiguration.self, data: responseData)
        case .Register?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .UserLogin?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .UpdateUser?:
            return ZFSerializer.serialize(modalType: ZFAutherizationResponse.self, data: responseData)
        case .CheckStatus?:
            return ZFSerializer.serialize(modalType: ZFSession.self, data: responseData)
        case .RouterLogin1?:
            return ZFSerializer.serialize(modalType: ZFRouterLoginResponse1.self, data: responseData)
        case .RouterLogin2?:
            return ZFSerializer.serialize(modalType: ZFSession.self, data: responseData)
        case .SessionInfo?:
            return ZFSerializer.serialize(modalType: ZFUserSessionInfoResponse.self, data: responseData)
        default:
            return nil
        }
    }
}

