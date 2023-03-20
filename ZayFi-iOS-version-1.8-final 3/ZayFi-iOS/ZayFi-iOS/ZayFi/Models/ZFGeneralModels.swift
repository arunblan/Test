//
//  ZFGeneralModels.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 27/12/21.
//

import Foundation

final class ZFAutherizationResponse: NSObject, Codable {
    var success: Bool
    var message: String?
    var userData: ZFUserData?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case userData = "data"
    }
}

final class ZFRouterLoginResponse1: NSObject, Codable {
    var success: Bool
    var message: String?
    var data: ZFRouterLoginResponse1Data?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

final class ZFRouterLoginResponse1Data: NSObject, Codable {
    var response: String
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

final class ZFConfiguration: NSObject, Codable {
    var miniOSVersion: String
    var currentiOSVersion: String
    var appStoreLink: String?
    enum CodingKeys: String, CodingKey {
        case miniOSVersion = "min_version_ios"
        case currentiOSVersion = "current_version_ios"
        case appStoreLink = "app_store_link"
    }
}
