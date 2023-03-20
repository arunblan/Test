import Foundation

class ZFSession: NSObject, Codable {

    var sessionStatus: Int = 0
    var challenge: String?
    var nasid: String?
    var redir: ZFRedir?
    var routerSession: ZFRouterSession?
    var accounting: ZFAccounting?
    var usageAllocation: ZFSessionUsageAllocation?
    var usageHistory: ZFSessionUsageHistory?
    
    var sessionAPIRequester: BESessionAPIRequester?
    
    enum CodingKeys: String, CodingKey {
        case sessionStatus = "clientState"
        case challenge = "challenge"
        case redir = "redir"
        case nasid = "nasid"
        case routerSession = "session"
        case accounting = "accounting"
    }
}

class ZFRedir: NSObject, Codable {
    var ipAddress: String
    var macAddress: String
    
    enum CodingKeys: String, CodingKey {
        case ipAddress = "ipAddress"
        case macAddress = "macAddress"
    }
}

class ZFRouterSession: NSObject, Codable {
    var sessionId: String
    var userName: String
    var startTime: Int32
    var sessionTimeout: Int32
    var terminateTime: Int32
    var idleTimeout: Int32
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "sessionId"
        case userName = "userName"
        case startTime = "startTime"
        case sessionTimeout = "sessionTimeout"
        case terminateTime = "terminateTime"
        case idleTimeout = "idleTimeout"
    }
}

class ZFAccounting: NSObject, Codable {
    var sessionTime: Int32
    var idleTime: Int32
    var inputOctets: Int32
    var outputOctets: Int32
    
    enum CodingKeys: String, CodingKey {
        case sessionTime = "sessionTime"
        case idleTime = "idleTime"
        case inputOctets = "inputOctets"
        case outputOctets = "outputOctets"
    }
}

class ZFUserSessionInfoResponse: NSObject, Codable {
    var success: Bool
    var message: String?
    var data: ZFSessionData?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

class ZFSessionData: NSObject, Codable {
    var user: ZFSessionUser?
    var session: ZFSessionDtails?
    var overallUsageHistory: ZFSessionUsageHistory?
    var usageAllocation: ZFSessionUsageAllocation?
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case session = "session"
        case overallUsageHistory = "overall_usage_history"
        case usageAllocation = "usage_allocation"
    }
}

class ZFSessionUser: NSObject, Codable {
    var name: String?
    var userName: String?
    var email: String?
    var mobile: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case userName = "username"
        case email = "email"
        case mobile = "mobile"
    }
}

class ZFSessionDtails: NSObject, Codable {
    var sessionId: String?
    var nasId: String?
    var macAddress: String?
    var ipAddress: String?
    var startTime: String?
    var endTime: String?
    var logoutReason: String?
    var downloads: String?
    var uploads: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case nasId = "nasid"
        case macAddress = "mac_address"
        case ipAddress = "ip_address"
        case startTime = "start_time"
        case endTime = "end_time"
        case logoutReason = "logout_reason"
        case downloads = "downloads"
        case uploads = "uploads"
    }
}

class ZFSessionUsageHistory: NSObject, Codable {
    var locationCount: Int?
    var usageData: String?
    var usageTime: String?
    
    enum CodingKeys: String, CodingKey {
        case locationCount = "location_count"
        case usageData = "usage_data"
        case usageTime = "usage_time"
    }
}

class ZFSessionUsageAllocation: NSObject, Codable {
    var dataAllocated: Int32?
    var timeAllocated: Int32?
    var dataBalance: Int32?
    var timeBalance: Int32?
    
    enum CodingKeys: String, CodingKey {
        case dataAllocated = "data_allocated"
        case timeAllocated = "time_allocated"
        case dataBalance = "data_balance"
        case timeBalance = "time_balance"
    }
}

