//
//  ZFForgotPassViewController.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 21/12/21.
//

import UIKit
import MBProgressHUD
import SkyFloatingLabelTextField

class ZFForgotPassViewController: UIViewController {
    
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var userNmaeField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        confirmationView.isHidden = true
        super.viewDidAppear(animated)
    }
    
    private func resetPassword() {
        if userNmaeField.text?.count != 0 && ZFExtras.isValidEmail(userNmaeField.text ?? "") {
            let user = ZFUser()
            user.email = userNmaeField.text
            MBProgressHUD.showAdded(to: self.view, animated: true)
            user.resetPassword { error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
                            strongSelf.confirmationView.isHidden = false
                            strongSelf.mainButton.setTitle("Login", for: .normal)
                        } else {
                            strongSelf.showValidationError(message: ZFError.ZFPasswordResetFailed.errorDescription!) { err in
                                ZFLog.debugLog("login failed.")
                            }
                        }
                    }
                }
            }
        } else {
            showValidationError(message: "Please enter a valid email address") { err in
                ZFLog.debugLog("Forgot Password: Form validation Failed.")
            }
        }
    }
    
    @IBAction func resend(_ sender: Any) {
        resetPassword()
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func requestForLink(_ sender: Any) {
        if confirmationView.isHidden {
            resetPassword()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

}
