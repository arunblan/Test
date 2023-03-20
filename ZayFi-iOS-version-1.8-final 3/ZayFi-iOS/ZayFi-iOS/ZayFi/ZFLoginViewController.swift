

import UIKit
import MBProgressHUD
import SkyFloatingLabelTextField

class ZFLoginViewController: UIViewController {
        
//    @IBOutlet weak var userNmaeField: SkyFloatingLabelTextField!
//    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        //userNmaeField.text = ZayFiManager.sharedInstance().user.email
        //passwordField.text = ""
    }
    
    @IBAction func switchSecureEntry(_ sender: Any) {
//        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
//        if let textRange = passwordField.textRange(from: passwordField.beginningOfDocument, to: passwordField.endOfDocument) {
//            passwordField.replace(textRange, withText: passwordField.text!)
//        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
    }
    
    @IBAction func signUp(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFRegisterViewController") as? ZFRegisterViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
       /* guard userNmaeField.text != "enabledebug" else {
            ZFDefault.setDataToDefault(value: true as Any, .isDebugMode)
            showValidationError(message: "DebugMode Enabled") { err in }
            return
        }
        if userNmaeField.text?.count != 0, passwordField.text?.count != 0 {
            if ZFExtras.isValidEmail(userNmaeField.text ?? "") {
                let user = ZFUser()
                user.email = userNmaeField.text
                MBProgressHUD.showAdded(to: self.view, animated: true)
                user.login(password: passwordField.text!) {response, error in
                    DispatchQueue.main.async { [weak self] in
                        if let strongSelf = self {
                            MBProgressHUD.hide(for: strongSelf.view, animated: true)
                            if error == nil {
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFHomeViewController") as? ZFHomeViewController
                                strongSelf.navigationController?.pushViewController(vc!, animated: true)
                            } else {
                                let errorMessage  = error?.errorDescription ?? "Login failed. Please enter valid username and password."
                                strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                                    ZFLog.debugLog("login failed.")
                                }
                            }
                        }
                    }
                }
            } else {
                showValidationError(message: MSG_NO_EMAIL) { err in
                    ZFLog.debugLog("Login: Form validation failed.")
                }
            }
        } else {
            showValidationError(message: MSG_NO_DATA) { err in
                ZFLog.debugLog("Login: Form validation failed.")
            }
        }*/
    }
    
    
    @IBAction func loginNew(_ sender: Any) {
//
//        print("\n📕 Login  - mobileNumberField: \(mobileNumberField.text!)\n")
//        print("\n📕 Login  - otpField: \(otpField.text!)\n")
        if mobileNumberField.text?.count != 0, otpField.text?.count != 0 {
        
            let user = ZFUser()
            user.phoneNumber = mobileNumberField.text
            user.otpNumber = otpField.text
            
           MBProgressHUD.showAdded(to: self.view, animated: true)
            user.getOtp(phoneNumber: mobileNumberField.text!) {response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFHomeViewController") as? ZFHomeViewController
                            strongSelf.navigationController?.pushViewController(vc!, animated: true)
                            ZFDefault.setDataToDefault(value: true, .isAuthenticate)
                            strongSelf.showValidationError(message: MSG_LOGIN1) { err in
                                ZFLog.debugLog("Register Completed")
                            }
                        } else {
                            let errorMessage  = error?.errorDescription ?? "Login failed"
                            strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                                ZFLog.debugLog("login failed.")
                            }
                        }
                    }
                }
            }
            
            
        } else {
            showValidationError(message: MSG_NO_DATA) { err in
                ZFLog.debugLog("Login: Form validation failed.")
            }
        }
        
    }
    
    
    @IBAction func getOtp(_ sender: Any) {
        
//        print("\n📕 Login  - mobileNumberField: \(mobileNumberField.text!)\n")
//        print("\n📕 Login  - otpField: \(otpField.text!)\n")
        if mobileNumberField.text?.count != 0 {
        
            let user = ZFUser()
            user.phoneNumber = mobileNumberField.text
            user.otpNumber = otpField.text
            
           MBProgressHUD.showAdded(to: self.view, animated: true)
            user.getOtp(phoneNumber: mobileNumberField.text!) {response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
                            strongSelf.showValidationError(message: MSG_LOGIN2) { err in
                                ZFLog.debugLog("Register Completed")
                            }
                        } else {
                            let errorMessage  = error?.errorDescription ?? "Login failed"
                            strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                                ZFLog.debugLog("login failed.")
                            }
                        }
                    }
                }
            }
            
            
        } else {
            showValidationError(message: MSG_NO_DATA) { err in
                ZFLog.debugLog("Login: Form validation failed.")
            }
        }
        
    }
    
    
    
    
    
    
}
