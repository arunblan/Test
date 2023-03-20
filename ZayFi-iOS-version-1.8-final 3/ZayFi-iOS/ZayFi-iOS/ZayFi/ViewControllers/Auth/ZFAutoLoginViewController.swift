//
//  ZFAutoLoginViewController.swift
//  ZayFi-iOS
//
//  Created by Arun KS on 17/05/22.
//

import UIKit
import MBProgressHUD

class ZFAutoLoginViewController: UIViewController {
    @IBOutlet weak var notYourAccountBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var notYourAccountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var autologinresponse: ZFAutherizationResponse?
    
    var user: ZFUser = ZayFiManager.sharedInstance().user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        notYourAccountBtn.setTitle("", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autologin()
    }
    
    func autologin() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        user.autoLoginToExistingSession { response, error in
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    if error == nil {
                        strongSelf.autologinresponse = response
                        strongSelf.descriptionLabel.text = "An active user session is found. Would you like to login with the mobile number on this device?"
                        
                    } else {
                        strongSelf.descriptionLabel.text = "An active user session is found. Would you like to login with the mobile number on this device?"
                        let errorMessage  = error?.errorDescription ?? "Getting auto login data Failed"
                        strongSelf.showValidationError(message: response?.message ?? errorMessage) { err in
                            ZFLog.errorLog("Getting auto login data Failed")
                        }
                    }
                }
            }
        }
    }
    

    @IBAction func agreeBtnTapped(_ sender: UIButton) {
        guard let userdata = autologinresponse?.userData else {
            return
        }
        ZFDefault.setDataToDefault(value: true, .isAuthenticate)
        ZayFiManager.sharedInstance().updateUserInfoNew(userdata)
        
        if userdata.email == nil || userdata.name == nil {
            
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
        
        
    }
    
    
    @IBAction func notYourAccountBtnTapped(_ sender: UIButton) {
        
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFGetOTPNavigationController") as! UINavigationController
            appDelegate.window?.rootViewController = controller
            appDelegate.window?.makeKeyAndVisible()
        }
        
        
    }
    
}
