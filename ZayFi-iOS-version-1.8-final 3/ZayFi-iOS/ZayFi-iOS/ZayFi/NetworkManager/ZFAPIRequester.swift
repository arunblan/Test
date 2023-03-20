//
//  BEAPIRequester.swift
//  BeCoMap-iOS-SDK
//
//  Created by Mithin Thomas on 06/06/19.
//  Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

enum ZFResponseStatus: Int {
    case ZFRequestSuccess
    
    // Error Status
    case ZFRequestCancelled
    case ZFRequestFailed
    case ZFRequestAuthenticationError
    case ZFBadRequest
    case ZFRequestOutdated
    case ZFServerError
};

enum ZFHTTPMethod: String {
    case HTTPGETMethod = "GET"
    case HTTPPOSTMethod = "POST"
    case HTTPPUTMethod = "PUT"
    case HTTPDELETEMethod = "DELETE"
    case HTTPPATCHMethod = "PATCH"
};

typealias BEAPIRequesterFinishedHandler = (_ status: ZFResponseStatus,_ responseObject: Any?,_ error: Error?) -> Void

/**
 BEAPIRequester
 - Version: 1.0
 - Copyright: Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
 */
class ZFAPIRequester {
    var user: ZFUser?
    var postData: Data? { get { return nil} }
    var url: URL? { get { return nil} }
    var contentType: String { get { return "application/json"} }
    var acceptType: String { get { return "application/json"} }
    var httPMethod: ZFHTTPMethod { get { return .HTTPGETMethod } }
    var sessionConfigurarion: URLSessionConfiguration {
        let cofig = URLSessionConfiguration.default
        cofig.urlCache = nil
        cofig.timeoutIntervalForRequest = 10
        cofig.timeoutIntervalForResource = 10
        cofig.urlCredentialStorage = nil
        cofig.requestCachePolicy = .reloadIgnoringLocalCacheData
        cofig.waitsForConnectivity = true
        return cofig
    }
    var session: URLSession {
        return URLSession(configuration: sessionConfigurarion)
    }
    var dataTask: URLSessionDataTask?
    var urlRequest: URLRequest {
        var request = URLRequest(url: url!)
        request.httpMethod = httPMethod.rawValue
        request.addValue(acceptType, forHTTPHeaderField: HTTP_HEADER_ACCEPT)
        request.addValue(contentType, forHTTPHeaderField: HTTP_HEADER_CONTENT_TYPE)
        request.addValue(ZFExtras.localTimeZoneAbbreviation, forHTTPHeaderField: HTTP_HEADER_TIME_ZONE)
        //request.addValue(ZFExtras.userAgent, forHTTPHeaderField: HTTP_HEADER_USER_AGENT)
        if let postData = postData {
            request.httpBody = postData
            request.addValue(String(postData.count), forHTTPHeaderField: HTTP_HEADER_CONTENT_LENGTH)
        }
        request.addValue(HTTP_HEADER_VALUE_IPHONE, forHTTPHeaderField: HTTP_HEADER_CLIENT_DEVICE)
        request.addValue(ZFExtras.deviceID, forHTTPHeaderField: HTTP_HEADER_DEVICE_ID)
        return request
    }
    private var requesterFinishedHandler: BEAPIRequesterFinishedHandler?
    private var isLoginRefreshed: Bool = false
    
    init(user: ZFUser? = nil, completionHandler: @escaping BEAPIRequesterFinishedHandler) {
        requesterFinishedHandler = completionHandler
        self.user = user
    }
    deinit {
        session.finishTasksAndInvalidate()
        requesterFinishedHandler = nil
        dataTask = nil
    }
    
    func startAPIRequest() {
        //(completionStatus,responseData,error) in
        print("urlRequest: \(urlRequest.description)")
        dataTask = session.dataTask(with: urlRequest) {[weak self] (data, response, error) -> Void in
            
            if let weakSelf = self {
                defer {
                    weakSelf.clear()
                }
                let httpResponse: HTTPURLResponse? = response as? HTTPURLResponse
                
                print("http reponseStatus: \(httpResponse?.statusCode ?? -1)")
                print("http description: \(httpResponse?.description ?? "Null Response")")
                
                let reponseStatus: ZFResponseStatus = weakSelf.handleNetworkResponse(httpResponse)
                var responseObj: Any?
                var reponseError: Error?
                ZFLog.debugLog("-------------------------------------")
                ZFLog.debugLog("Request URL: \(String(describing: self?.url?.absoluteString))")
                ZFLog.debugLog("Request Header: \(self?.urlRequest.allHTTPHeaderFields as Any)")
                if weakSelf.postData != nil {
                    ZFLog.debugLog("PostData: \(String(data: weakSelf.postData!, encoding: String.Encoding.utf8) ?? "Null")")
                }
                ZFLog.debugLog("Response: \(response as Any)")
                if let responseDta = data {
                    let jsonResponse = try? JSONSerialization.jsonObject(with: responseDta, options: [])
                    print("jsonResponse: \(String(describing: jsonResponse))")
                    
                    responseObj = weakSelf.handleResponseData(responseData: responseDta)
                    ZFLog.debugLog("JSON Response:\(String(data: responseDta, encoding: String.Encoding.utf8) ?? "Failed to convert response data to string")")
                }
                if reponseStatus != .ZFRequestSuccess {
                    reponseError = error == nil ? ZFError.ZFRequestFailed : error
                }
                weakSelf.requesterFinishedHandler?(reponseStatus,responseObj,reponseError)
            }
        }
        dataTask?.resume()
    }
    
    func handleResponseData(responseData: Data) -> Any? {
        return nil
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse?) -> ZFResponseStatus {
        if let httpResponse =  response {
            switch httpResponse.statusCode {
            case 200...299: return .ZFRequestSuccess
            case 400: return .ZFBadRequest
            case 401: return .ZFRequestAuthenticationError
            case 402...499: return .ZFBadRequest
            case 500...599: return .ZFServerError
            case 600: return .ZFRequestOutdated
            default: return .ZFRequestFailed
            }
        }
        return .ZFRequestFailed
    }
    
    func clear() {
        requesterFinishedHandler = nil
        session.invalidateAndCancel()
        dataTask?.cancel()
        user = nil
    }
}
