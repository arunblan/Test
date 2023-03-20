
import Foundation

class ZFUser: NSObject {
    public var userID: Int32?
    public var email: String?
    public var name: String?
    public var phoneNumber: String?
    public var passwordHash: String?
    public var otpNumber: String?
    
    
    var userSession: ZFSession?
    var sessionAPIRequester: BESessionAPIRequester?
    
    override init() {
        super.init()
    }
    
    private func updateUser(with data: ZFUserData) {
        ZayFiManager.sharedInstance().updateUserInfoNew(data)
    }
    
    
    func loginNew(phoneNumber: String, completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse {
                if response.success == true, let userData =  response.userData {
                    self.updateUser(with: userData)
                    completionHandler(response, nil)
                } else {
                    completionHandler(response,.ZFLoginFailed)
                }
            } else {
                completionHandler(nil,.ZFLoginFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .loginNew
        //self.sessionAPIRequester?.password = password
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    
    func getOtp(phoneNumber: String, completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse {
                if response.success == true, let userData =  response.userData {
//                    self.updateUser(with: userData)
                    completionHandler(response, nil)
                } else {
                    completionHandler(response,.ZFLoginFailed)
                }
            } else {
                completionHandler(nil,.ZFLoginFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .GetOTPLogin
        //self.sessionAPIRequester?.password = password
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    
    func validateOtp(mobileNumber: String, completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse {
               
                if response.success == true, let userData =  response.userData {
                     self.updateUser(with: userData)
                     completionHandler(response, nil)
                    ZFLog.debugLog("register_new - userData : \(userData)")
                } else {
                    completionHandler(response,.ZFRegistrationFailed)
                }
                
            } else {
                completionHandler(nil,.ZFRegistrationFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .ValidateOtp
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    
    func register_new(email: String, mobileNumber: String, completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> (Void)) {
//        ZFLog.debugLog("register_new - email : \(email)")
//        ZFLog.debugLog("register_new - mobileNumber : \(mobileNumber)")
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse {
               
                if response.success == true, let userData =  response.userData {
                    self.updateUser(with: userData)
                    completionHandler(response, nil)
                    ZFLog.debugLog("register_new - userData : \(userData)")
                } else {
                    completionHandler(response,.ZFRegistrationFailed)
                }
                
            } else {
                completionHandler(nil,.ZFRegistrationFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .Register_New
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func login(password: String, completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse {
                if response.success == true, let userData =  response.userData {
                    self.updateUser(with: userData)
                    completionHandler(response, nil)
                } else {
                    completionHandler(response,.ZFLoginFailed)
                }
            } else {
                completionHandler(nil,.ZFLoginFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .UserLogin
        self.sessionAPIRequester?.password = password
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func register(password: String, completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse {
                if response.success == true, let userData =  response.userData {
                    self.updateUser(with: userData)
                    completionHandler(response, nil)
                } else {
                    completionHandler(response,.ZFRegistrationFailed)
                }
            } else {
                completionHandler(nil,.ZFRegistrationFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .Register
        self.sessionAPIRequester?.password = password
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func registerForPush(completionHandler: @escaping(_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if error == nil {
                completionHandler(nil)
            } else {
                completionHandler(.ZFRegistrationFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .RegisterPush
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func update(userInfo:ZFUser, completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: userInfo) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse, let userData =  response.userData {
                if response.success == true {
                    self.updateUser(with: userData)
                    completionHandler(response, nil)
                } else {
                    completionHandler(response,.ZFUserUpdateFailed)
                }
            } else {
                completionHandler(nil,.ZFUserUpdateFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .UpdateUser
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func resetPassword(completionHandler: @escaping(_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if completionStatus == .ZFRequestSuccess {
                completionHandler(nil)
            } else {
                completionHandler(.ZFPasswordResetFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .ResetPassword
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func checkSessionStatus(completionHandler: @escaping(_ session: ZFSession?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { [weak self] (completionStatus,responseData,error) in
            
            switch completionStatus {
            case .ZFRequestSuccess:
                if let session  = responseData as? ZFSession {
                    self?.userSession = session
                    completionHandler(session)
                }
                break;
            default:
                completionHandler(nil)
                break
            }
        }
        self.sessionAPIRequester?.actionType = .CheckStatus
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func routerLogin(completionHandler: @escaping(_ response: ZFSession?,_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { [weak self] (completionStatus,responseData,error) in
            switch completionStatus {
            case .ZFRequestSuccess:
                if let response  = responseData as? ZFRouterLoginResponse1, let secretResponse = response.data?.response {
                    self?.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
                        if let response  = responseData as? ZFSession {
                            completionHandler(response,nil)
                        } else {
                            ZFLog.debugLog("Router Login: Failed to call - https://api.zayfi.com/api/user/wifi/hotspot/login")
                            completionHandler(nil,ZFError.ZFLoginFailed)
                        }
                    }
                    self?.sessionAPIRequester?.actionType = .RouterLogin2
                    self?.sessionAPIRequester?.secretResponse = secretResponse
                    self?.sessionAPIRequester?.startAPIRequest()
                    self?.sessionAPIRequester?.session.finishTasksAndInvalidate()
                } else {
                    completionHandler(nil,ZFError.ZFLoginFailed)
                }
                break;
            default:
                completionHandler(nil,ZFError.ZFLoginFailed)
                break
            }
        }
        self.sessionAPIRequester?.actionType = .RouterLogin1
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func getRouterSession(completionHandler: @escaping(_ session: ZFUserSessionInfoResponse?, _ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            switch completionStatus {
            case .ZFRequestSuccess:
                if let response  = responseData as? ZFUserSessionInfoResponse {
                    completionHandler(response, nil)
                } else {
                    completionHandler(nil,ZFError.ZFRequestFailed)
                }
                break;
            default:
                completionHandler(nil,ZFError.ZFRequestFailed)
                break
            }
        }
        self.sessionAPIRequester?.actionType = .SessionInfo
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func logout(completionHandler: @escaping(_ error: ZFError?) -> (Void)) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { [weak self] (completionStatus,responseData,error) in
            self?.sessionAPIRequester?.clear()
            self?.sessionAPIRequester = BESessionAPIRequester.init(user: self) { [weak self] (completionStatus,responseData,error) in
                defer {
                    self?.sessionAPIRequester = nil
                }
                self?.userSession = nil
                completionHandler(nil)
            }
            self?.sessionAPIRequester?.actionType = .Logout
            self?.sessionAPIRequester?.startAPIRequest()
            self?.sessionAPIRequester?.session.finishTasksAndInvalidate()
        }
        self.sessionAPIRequester?.actionType = .Terminate
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func autoLoginToExistingSession(completionHandler: @escaping(_ response: ZFAutherizationResponse?,_ error: ZFError?) -> Void) {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self) { (completionStatus,responseData,error) in
            if let response =  responseData as? ZFAutherizationResponse {
               
                if response.success == true, let userData =  response.userData {
//                     self.updateUser(with: userData)
                     completionHandler(response, nil)
                    ZFLog.debugLog("autoLoginToExistingSession - userData : \(userData)")
                } else {
                    completionHandler(response,.ZFRegistrationFailed)
                }
                
            } else {
                completionHandler(nil,.ZFRegistrationFailed)
            }
        }
        self.sessionAPIRequester?.actionType = .AutoLogin
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
}

class ZFUserData: NSObject, Codable {
    var userID: Int32?
    var email: String?
    var name: String?
    var mobile: String?
    var userName: String?
    var passwordHash: String?
    
    var userSession: ZFSession?
    var sessionAPIRequester: BESessionAPIRequester?
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case email = "email"
        case name = "name"
        case mobile = "mobile"
        case userName = "username"
        case passwordHash = "password_hash"
    }
}
