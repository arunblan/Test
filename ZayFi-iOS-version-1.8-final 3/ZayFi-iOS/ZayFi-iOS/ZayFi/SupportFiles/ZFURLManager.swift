

//  Created by Mithin Thomas on 16/05/19.
//  Copyright © 2021 Mithin Thomas. All rights reserved.
//

import Foundation

enum ZFAPIVersions: String {
    case v0 = "v0"
    case v1 = "v1"
}

var ZFURLapiServicesRadiusdeskEndpoint: String {
    return "https://api.zayfi.com"
}

var ZFURLapiServicesLocalEndpoint: String {
    return "http://172.22.100.1:3990"
}

var ZFURLapiRegister: String {
    return "\(ZFURLapiServicesRadiusdeskEndpoint)/api/user/wifi/register"
}

var ZFURLapiUserLogin: String {
    return "\(ZFURLapiServicesRadiusdeskEndpoint)/api/user/wifi/login"
}

var ZFURLapiUserResetPassowrd: String {
    return "\(ZFURLapiServicesRadiusdeskEndpoint)/api/user/wifi/forgot-password"
}

var ZFURLapiRegisterPush: String {
    return "https://dashboard.zaytech.ae/api/notification/register_token"
}

var ZFURLapiUpdateUser: String {
    return "\(ZFURLapiServicesRadiusdeskEndpoint)/api/user/wifi/update"
}
var ZFURLapiSessionInfo: String {
    return "\(ZFURLapiServicesRadiusdeskEndpoint)/api/user/wifi/session/info"
}

var ZFURLapiStatus: String {
    return "\(ZFURLapiServicesLocalEndpoint)/json/status"
}

var ZFURRouterLogin1: String {
    return "\(ZFURLapiServicesRadiusdeskEndpoint)/api/user/wifi/hotspot/login"
}

var ZFURRouterLogin2: String {
    return "\(ZFURLapiServicesLocalEndpoint)/json/logon"
}

var ZFURLapiSessionTerminate: String {
    return "\(ZFURLapiServicesRadiusdeskEndpoint)/api/user/wifi/session/terminate"
}

var ZFURLapiLogout: String {
    return "\(ZFURLapiServicesLocalEndpoint)/json/logoff"
}
var ZFURLapiGetCampaign: String {
    return "https://dashboard.zaytech.ae/api/get-campaign-info"
}

