import Foundation

/**
 BEError
 - Version: 1.0
 - Copyright: Copyright © 2019 GlobeCo Technologies Pvt Ltd. All rights reserved.
 */
public enum ZFError: Error  {
    
    /**
     BERequestFailed
     * Generic error. will trigger when a request is failed
     */
    case ZFRequestFailed
    
    /**
     BEInvalidToken
     * Will be triggered, if the token provedided on Configuration is Invalid token.
     */
    case ZFInvalidToken
    
    /**
     ZFInvalidConnection
     * Will be triggered, if you are not connected to the router
     */
    case ZFInvalidConnection
    
    /**
     ZFRegistrationFailed
     * Will be triggered, if RegistrationFailed
     */
    case ZFRegistrationFailed
    case ZFPasswordResetFailed
    case ZFLoginFailed
    case ZFUserUpdateFailed
    case ZFFailedToFetchUserSession
    
}

extension ZFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ZFRequestFailed:
            return NSLocalizedString("Request failed.", comment: "")
        case .ZFInvalidToken:
            return NSLocalizedString("Invalid access token/consumer key.", comment: "")
        case .ZFInvalidConnection:
            return NSLocalizedString("You are not connected to ZayFi WiFi network, Please re-launch app after a valid connection.", comment: "")
        case .ZFRegistrationFailed:
            return NSLocalizedString("Registration Failed", comment: "")
        case .ZFPasswordResetFailed:
            return NSLocalizedString("Failed to to Reset password. Please try again.", comment: "")
        case .ZFLoginFailed:
            return NSLocalizedString("Login failed. Please enter valid username and password.", comment: "")
        case .ZFUserUpdateFailed:
            return NSLocalizedString("User update failed. Please try again.", comment: "")
        case .ZFFailedToFetchUserSession:
            return NSLocalizedString("Failed to fetch user session details.", comment: "")
        }
    }
}

