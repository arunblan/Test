//
//  ZFVerifyOTPViewController.swift
//  ZayFi-iOS
//
//  Created by Arun KS on 17/05/22.
//

import UIKit
import MBProgressHUD


class ZFVerifyOTPViewController: UIViewController {
    
    var mobileNumber: String = ""
    
    var OTPTextfields: [UITextField]!
    
    var codeOTP : String = ""
    

    @IBOutlet weak var firstDigitOTP: UITextField!
    @IBOutlet weak var secondDigitOTP: UITextField!
    @IBOutlet weak var thirdDigitOTP: UITextField!
    @IBOutlet weak var fourthDigitOTP: UITextField!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        OTPTextfields = [firstDigitOTP, secondDigitOTP, thirdDigitOTP, fourthDigitOTP]
        
        for texfield in OTPTextfields {
            texfield.delegate = self
            texfield.textContentType = .oneTimeCode
            texfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        
       let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.gray]

        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black]

        let attributedString1 = NSMutableAttributedString(string:"Enter the OTP from SMS which we sent to the number ", attributes:attrs1)

//        let attributedString2 = NSMutableAttributedString(string: mobileNumber, attributes: attrs2)
//
//        attributedString1.append(attributedString2)
        self.titleLabel.attributedText = attributedString1
        
    }
    
    
    @IBAction func verifyOTPBtnTapped(_ sender: UIButton) {
        
        if codeOTP.count == 4 {
            
            
            let user = ZFUser()
            
            user.phoneNumber = mobileNumber
            user.otpNumber = codeOTP

            MBProgressHUD.showAdded(to: self.view, animated: true)
            user.validateOtp(mobileNumber: mobileNumber) { response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
                            
                            ZFDefault.setDataToDefault(value: true, .isAuthenticate)
                            
                            if response?.userData?.email == nil || response?.userData?.name == nil {
                                
                                
                                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                    
                                    let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFSettingsNavigationController") as! UINavigationController
                                    appDelegate.window?.rootViewController = controller
                                    appDelegate.window?.makeKeyAndVisible()
                                }
                                
                            } else {
                                
                                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                    
                                    let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFHomeNavigationController") as! UINavigationController
                                    appDelegate.window?.rootViewController = controller
                                    appDelegate.window?.makeKeyAndVisible()
                                }
                                
                            }
                            
                            
                            
//                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFLoginViewController") as? ZFLoginViewController
//                            strongSelf.navigationController?.pushViewController(vc!, animated: true)
//                            strongSelf.showValidationError(message: MSG_RGISTER2) { err in
//                                ZFLog.debugLog("Register Completed")
//                            }
                            
                            
                            
                            
//                            strongSelf.showValidationError(message: MSG_RGISTER1) { err in
//                                ZFLog.debugLog("OTP send")
//                            }
                        } else {
                            let errorMessage  = error?.errorDescription ?? "OTP Verification Failed"
                            strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                                ZFLog.errorLog("OTP Verification Failed")
                            }
                        }
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    func submitOTP(){
//        delegateOTP?.OTPFullyEntered(otp: codeOTP)
    }
    
    func textFieldSwap(_ textField: UITextField){
        var itemNumber = 0
        for checkTextFeild in OTPTextfields{
            if textField == checkTextFeild{
                break
            }
            itemNumber = itemNumber + 1
        }
        if textField.text != ""{
            if itemNumber != OTPTextfields.count - 1{
            OTPTextfields[itemNumber+1].becomeFirstResponder()
            }else{
                textField.resignFirstResponder()
                submitOTP()
            }
        }else{
            if itemNumber != 0{
            OTPTextfields[itemNumber-1].becomeFirstResponder()
            }else{
                return
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//                textField.text = "454645" ///For testing auto fill OTP Code
                
                if let otpCode = textField.text, otpCode.count > 3{
                    codeOTP = otpCode
                    var count = 0
                    for textfield in OTPTextfields {
                        textfield.text = String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: count)])
                        count = count + 1
                    }
                    self.view.endEditing(true)
                    submitOTP()
                }else{
                    setOTPCode()
                    textFieldSwap(textField)
                }
    }
    

    
    func setOTPCode(){
        var string : String = ""
        for textfield in OTPTextfields{
            if let text = textfield.text{
            string = string + text
            }
        }
        codeOTP = string
    }
    

}

    
extension ZFVerifyOTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isClearing = string == ""
        let isTextfieldEmpty = textField.text == ""
        if isTextfieldEmpty || isClearing{
            return true
        }else{
            return false
        }
    }
}
