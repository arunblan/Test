//
//  ZFCampaign.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 16/01/22.
//

import Foundation

class ZFCampaignAPIResponse: NSObject, Codable {
    var success: Bool
    var message: String?
    var data: ZFCampaign?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

class ZFCampaign: NSObject, Codable {
    var homepageBanner: String?
    var contentUrl: String?
    var nextUpdate: String?
    var cta: ZFCTAData?
    
    enum CodingKeys: String, CodingKey {
        case homepageBanner = "homepage_banner"
        case contentUrl = "content_url"
        case nextUpdate = "next_update_at"
        case cta = "cta_data"
    }
}

class ZFCTAData: NSObject, Codable {
    var iosInfo: ZFiOSCampaign

    enum CodingKeys: String, CodingKey {
        case iosInfo = "ios"
    }
}

class ZFiOSCampaign: NSObject, Codable {
    var btnUrl: String?
    var btnText: String?
    
    enum CodingKeys: String, CodingKey {
        case btnUrl = "btn_url"
        case btnText = "btn_text"
    }
}
/**{
 "success": true,
 "message": "Campaign url fetched",
 "data": {
     "homepage_banner": "https:\/\/dashboard.zaytech.ae\/upload\/banner\/banner_kulcha_king_01.jpg",
     "content_url": "https:\/\/dashboard.zaytech.ae\/ad-campaign\/content",
     "next_update_at": "2022-01-21 20:36:40",
     "cta_data": {
         "android": {
             "btn_url": "https:\/\/play.google.com\/store\/apps\/details?id=com.quoodo.android&hl=en_IN&gl=US",
             "btn_text": "Install App"
         },
         "ios": {
             "btn_url": "https:\/\/apps.apple.com\/us\/app\/quoodo-com\/id1485201310",
             "btn_text": "Install App"
         }
     }
 }
}*/
