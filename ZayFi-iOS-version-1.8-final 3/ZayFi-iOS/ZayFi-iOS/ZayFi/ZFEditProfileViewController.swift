//
//  ZFEditProfileViewController.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 21/12/21.
//

import UIKit
import MBProgressHUD

class ZFEditProfileViewController: UIViewController {
    let user = ZayFiManager.sharedInstance().user
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var userNmaeField: UITextField!
    @IBOutlet weak var mobField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setTitle("", for: .normal)
        
        
        nameField.isUserInteractionEnabled = true
        userNmaeField.isUserInteractionEnabled = true
        userNmaeField.isEnabled = true
        
        mobField.isUserInteractionEnabled = false
        
        userNmaeField.text = user.email
        mobField.text = user.phoneNumber
        nameField.text = user.name
    }
    
    private func validateFields() -> Bool  {
        guard user.email != userNmaeField.text || mobField.text != user.phoneNumber || nameField.text != user.name else {
            return false
        }
        if nameField.text?.count != 0 {
            if ZFExtras.isValidEmail(userNmaeField.text ?? "") {
                if mobField.text?.count ?? 0 > 9 {
                    return true
                } else {
                    showValidationError(message: MSG_NO_PHONE) { err in
                        ZFLog.debugLog("EditProfile: Form validation failed.")
                    }
                    return false
                }
                
            } else {
                showValidationError(message: MSG_NO_EMAIL) { err in
                    ZFLog.debugLog("EditProfile: Form validation failed.")
                }
                return false
            }
        } else {
            showValidationError(message: MSG_NO_DATA) { err in
                ZFLog.debugLog("EditProfile: Form validation failed.")
            }
            return false
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        if validateFields() {
            let newUser = ZFUser.init()
            newUser.name = nameField.text
            newUser.email = userNmaeField.text
            newUser.phoneNumber = mobField.text
            MBProgressHUD.showAdded(to: self.view, animated: true)
            user.update(userInfo: newUser) { response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
                            strongSelf.showValidationError(message: "User profile updated.") { err in
                                strongSelf.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            let errorMessage  = error?.errorDescription ?? "User profile updated failed."
                            strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                                ZFLog.errorLog("Profile update Failed")
                            }
                        }
                    }
                }

            }
        }
    }

}
