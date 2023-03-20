//
//  ZFSettingsViewController.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 21/12/21.
//

import UIKit
import MBProgressHUD

class ZFSettingsViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var accountSettingsBtn: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var termsAndConditionsBtn: UIButton!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    
    @IBOutlet weak var debuggerButton: UIButton!
    
    let zfSettings: [Int: [String:String]] = [
        0:[
            "title":"Account Settings",
            "url":""
        ],
        1:[
            "title":"Privacy Policy",
            "url":"https://www.zayfi.com/privacy-policy"
        ],
        2:[
            "title":"Terms and Conditions",
            "url":"https://www.zayfi.com/terms-conditions"
        ],
        3:[
            "title":"Feedback",
            "url":"https://www.zayfi.com/support"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debuggerButton.isHidden = true
        
        backBtn.setTitle("", for: .normal)
        accountSettingsBtn.setTitle("", for: .normal)
        privacyPolicyBtn.setTitle("", for: .normal)
        termsAndConditionsBtn.setTitle("", for: .normal)
        feedbackBtn.setTitle("", for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debuggerButton.isHidden = true
        if ZFDefault.getDataFromDefault(.isDebugMode) as? Bool == true {
            debuggerButton.isHidden = false
        }
    }
    
    @IBAction func goToDetail(_ sender: UIButton) {
        if sender.tag == 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFEditProfileViewController") as? ZFEditProfileViewController
            navigationController?.pushViewController(vc!, animated: true)
        } else {
            if let pageDetails = zfSettings[sender.tag] {
                let webViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFWebViewController") as! ZFWebViewController
                webViewController.webLink = pageDetails["url"]!
                webViewController.headerTitle = pageDetails["title"]!
                navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ZayFiManager.sharedInstance().user.logout { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                ZFDefault.removeDataFromDefault(.isAuthenticate)
                
                ZayFiManager.sharedInstance().updateUserInfo(nil)
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)
                    NotificationCenter.default.removeObserver(Notification.Name("PUSHRECIEVED"))
                    
                    let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFGetOTPNavigationController") as! UINavigationController
                    appDelegate.window?.rootViewController = controller
                    appDelegate.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToDebugPage(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFDebugViewController") as! ZFDebugViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}


