//
//  ZFGetOTPViewController.swift
//  ZayFi-iOS
//
//  Created by Arun KS on 17/05/22.
//

import UIKit
import MBProgressHUD
import SKCountryPicker

class ZFGetOTPViewController: UIViewController {
    
    @IBOutlet weak var countrycodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        countrycodeTextField.text = "971"
        setupPickerViewForTextField()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(ZayFiManager.sharedInstance().isAutoLoginStatusChecked) {
            isAutoLogginSessionAvailable()
        }
        
    }
    
    private func setupPickerViewForTextField() {
        let picketView = CountryPickerView.loadPickerView(allCountryList: CountryManager.shared.countries, selectedCountry: Country(countryCode: "AE")) { [weak self] (country) in
            
            guard let self = self,
                let digitCountrycode = country.digitCountrycode else {
                return
            }
            let text = "\(digitCountrycode)"
 //           let text = "\(digitCountrycode) \(country.countryCode)"
            self.countrycodeTextField.text = text
        }
        
        // Set pick list menually.
        picketView.setPickList(codes: "IN", "AE", "AU")
        
        countrycodeTextField.inputView = picketView
        
        let toolBar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.barStyle = .default
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [doneButton]
        toolBar.isUserInteractionEnabled = true
        countrycodeTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTapped() {
        self.countrycodeTextField.resignFirstResponder()
    }
    
    @IBAction func getOtpBtnTapped(_ sender: Any) {
        
        if phoneNumberTextField.text?.count != 0 && countrycodeTextField.text?.count != 0 {

            let user = ZFUser()
            user.phoneNumber = countrycodeTextField.text! + phoneNumberTextField.text!
            user.otpNumber = ""

           MBProgressHUD.showAdded(to: self.view, animated: true)
            user.getOtp(phoneNumber: countrycodeTextField.text! + phoneNumberTextField.text!) {response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil {
//
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFVerifyOTPViewController") as? ZFVerifyOTPViewController
                            vc!.mobileNumber = strongSelf.countrycodeTextField.text! + strongSelf.phoneNumberTextField.text!
                            strongSelf.navigationController?.pushViewController(vc!, animated: true)
                            
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
    
    
    
    func isAutoLogginSessionAvailable() {
        
        let user = ZayFiManager.sharedInstance().user
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        user.checkSessionStatus { session in
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    ZayFiManager.sharedInstance().isAutoLoginStatusChecked = true
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    if let userSession = session, userSession.sessionStatus == 1 {
                        
//                        if !(userSession.routerSession?.userName == "freewifiuser" || userSession.routerSession?.userName == "freewifi") {
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                
                                let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFAutoLoginNavigationController") as! UINavigationController
                                appDelegate.window?.rootViewController = controller
                                appDelegate.window?.makeKeyAndVisible()
                            }
//                        }
                    } else {
                        
                        if user.userSession?.redir?.macAddress != nil {
//                            strongSelf.sessionAlertLabel.text = "Connected to ZyFi Network."
//                            Thread.sleep(forTimeInterval: 1.0)
//                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFLoginViewController") as? ZFLoginViewController
//                            strongSelf.navigationController?.pushViewController(vc!, animated: true)
                        } else {
//                            strongSelf.refreshButton.isHidden = false
//                            strongSelf.sessionAlertLabel.text = "You are not connected to ZayFi WiFi network or Don't have permission to connect to the local network, please click re-check after a valid connection."
                        }
                        
                        
                    }
                }
            }
        }
    }

}
