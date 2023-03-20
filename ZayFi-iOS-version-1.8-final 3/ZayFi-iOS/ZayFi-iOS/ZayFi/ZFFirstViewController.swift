

import UIKit

class ZFFirstViewController: UIViewController {
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var sessionAlertLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh(refreshButton as Any)
    }
    
    private func checkSession() {
        refreshButton.isHidden = true
        let user = ZayFiManager.sharedInstance().user
        user.checkSessionStatus { session in
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    if let userSession = session, userSession.sessionStatus == 1 {
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFHomeViewController") as? ZFHomeViewController
                        strongSelf.navigationController?.pushViewController(vc!, animated: true)
                    } else {
                        if user.userSession?.redir?.macAddress != nil {
                            strongSelf.sessionAlertLabel.text = "Connected to ZyFi Network."
                            Thread.sleep(forTimeInterval: 1.0)
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFLoginViewController") as? ZFLoginViewController
                            strongSelf.navigationController?.pushViewController(vc!, animated: true)
                        } else {
                            strongSelf.refreshButton.isHidden = false
                            strongSelf.sessionAlertLabel.text = "You are not connected to ZayFi WiFi network or Don't have permission to connect to the local network, please click re-check after a valid connection."
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        sessionAlertLabel.text = "Validating Session..."
        checkSession()
    }
}
