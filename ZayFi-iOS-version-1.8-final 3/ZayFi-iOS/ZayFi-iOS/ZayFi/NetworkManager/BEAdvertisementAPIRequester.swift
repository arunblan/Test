//
//  BESessionAPIRequester.swift
//  BeCoMap-iOS-SDK
//
//  Created by Mithin Thomas on 06/06/19.
//  Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
//

import Foundation

enum BEAdvertisementAPIActionType: Int {
    case GetAdd
};

/**
 BESDKAPIRequester
 - Version: 1.0
 - Copyright: Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
 */
final class BEAdvertisementAPIRequester: ZFAPIRequester {
    
    var actionType: BEAdvertisementAPIActionType?
        
    override var httPMethod: ZFHTTPMethod {
        switch actionType {
        case .GetAdd?:
            return .HTTPGETMethod
        default:
            return .HTTPGETMethod
        }
    }
    
    override var url: URL {
        switch actionType {
        case .GetAdd?:
            return URL(string: "\(ZFURLapiGetCampaign)/?session_id=\(user?.userSession?.routerSession?.sessionId ?? "")&nas_id=\(user?.userSession?.nasid ?? "")")!
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
        return nil
    }
    
    override func handleResponseData(responseData: Data) -> Any? {
        switch actionType {
        case .GetAdd?:
            return ZFSerializer.serialize(modalType: ZFCampaignAPIResponse.self, data: responseData)
        default:
            return nil
        }
    }
}

