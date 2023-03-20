

import UIKit
import MBProgressHUD
import SkyFloatingLabelTextField

class ZFRegisterViewController: UIViewController {
    
    var session: ZFSession?
    
//    @IBOutlet weak var nameField: UITextField!
//    @IBOutlet weak var userNmaeField: UITextField!
//    @IBOutlet weak var mobField: UITextField!
//    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    @IBAction func switchSecureEntry(_ sender: Any) {
//        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
//        if let textRange = passwordField.textRange(from: passwordField.beginningOfDocument, to: passwordField.endOfDocument) {
//            passwordField.replace(textRange, withText: passwordField.text!)
//        }
//    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func register(_ sender: Any) {
        if validateFieldsWithOutOtp() {
            
            let user = ZFUser()
            user.email = emailField.text
            user.phoneNumber = mobileNumberField.text

               MBProgressHUD.showAdded(to: self.view, animated: true)
            user.register_new(email: emailField.text!, mobileNumber:mobileNumberField.text!) { response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
//                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFHomeViewController") as? ZFHomeViewController
//                            strongSelf.navigationController?.pushViewController(vc!, animated: true)
                            strongSelf.showValidationError(message: MSG_RGISTER1) { err in
                                ZFLog.debugLog("OTP send")
                            }
                        } else {
                            let errorMessage  = error?.errorDescription ?? "Registration Failed"
                            strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                                ZFLog.errorLog("registration Failed")
                            }
                        }
                    }
                }
            }
         
            
            
            
        }
    }
    
    @IBAction func validateOtpServer(_ sender: Any) {
        if validateFields() {
            
            
            let user = ZFUser()
            
            user.phoneNumber = mobileNumberField.text
            user.otpNumber = otpField.text

               MBProgressHUD.showAdded(to: self.view, animated: true)
            user.validateOtp(mobileNumber: mobileNumberField.text!) { response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
                            
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFLoginViewController") as? ZFLoginViewController
                            strongSelf.navigationController?.pushViewController(vc!, animated: true)
                            strongSelf.showValidationError(message: MSG_RGISTER2) { err in
                                ZFLog.debugLog("Register Completed")
                            }
//                            strongSelf.showValidationError(message: MSG_RGISTER1) { err in
//                                ZFLog.debugLog("OTP send")
//                            }
                        } else {
                            let errorMessage  = error?.errorDescription ?? "Registration Failed"
                            strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                                ZFLog.errorLog("registration Failed")
                            }
                        }
                    }
                }
            }
            
            
        }
        
    }

    
    private func validateFields() -> Bool  {
        if emailField.text?.count != 0 {
            if ZFExtras.isValidEmail(emailField.text ?? "") {
                if mobileNumberField.text?.count ?? 0 > 3 {
                    if otpField.text?.count != 0 {
                        return true
                    } else {
                        showValidationError(message: MSG_NO_OTP) { err in
                            ZFLog.debugLog("Register: Form validation failed.")
                        }
                        return false
                    }
                } else {
                    showValidationError(message: MSG_NO_PHONE) { err in
                        ZFLog.debugLog("Register: Form validation failed.")
                    }
                    return false
                }
                
            } else {
                showValidationError(message: MSG_NO_EMAIL) { err in
                    ZFLog.debugLog("Register: Form validation failed.")
                }
                return false
            }
        } else {
            showValidationError(message: MSG_NO_DATA) { err in
                ZFLog.debugLog("Register: Form validation failed.")
            }
            return false
        }
    }
    
    
    
    private func validateFieldsWithOutOtp() -> Bool  {
        if emailField.text?.count != 0 {
            if ZFExtras.isValidEmail(emailField.text ?? "") {
                if mobileNumberField.text?.count ?? 0 > 3 {
//                    if otpField.text?.count != 0 {
//                        return true
//                    } else {
//                        showValidationError(message: MSG_NO_OTP) { err in
//                            ZFLog.debugLog("Register: Form validation failed.")
//                        }
//                        return false
//                    }
                    return true
                } else {
                    showValidationError(message: MSG_NO_PHONE) { err in
                        ZFLog.debugLog("Register: Form validation failed.")
                    }
                    return false
                }
                
            } else {
                showValidationError(message: MSG_NO_EMAIL) { err in
                    ZFLog.debugLog("Register: Form validation failed.")
                }
                return false
            }
        } else {
            showValidationError(message: MSG_NO_DATA) { err in
                ZFLog.debugLog("Register: Form validation failed.")
            }
            return false
        }
    }
    
    
    
    
    
    
}



        
//    private func validateFields() -> Bool  {
//        if nameField.text?.count != 0 {
//            if ZFExtras.isValidEmail(userNmaeField.text ?? "") {
//                if mobField.text?.count ?? 0 > 3 {
//                    if passwordField.text?.count != 0 {
//                        return true
//                    } else {
//                        showValidationError(message: MSG_NO_PASSWORD) { err in
//                            ZFLog.debugLog("Register: Form validation failed.")
//                        }
//                        return false
//                    }
//                } else {
//                    showValidationError(message: MSG_NO_PHONE) { err in
//                        ZFLog.debugLog("Register: Form validation failed.")
//                    }
//                    return false
//                }
//
//            } else {
//                showValidationError(message: MSG_NO_EMAIL) { err in
//                    ZFLog.debugLog("Register: Form validation failed.")
//                }
//                return false
//            }
//        } else {
//            showValidationError(message: MSG_NO_DATA) { err in
//                ZFLog.debugLog("Register: Form validation failed.")
//            }
//            return false
//        }
//    }
//}
