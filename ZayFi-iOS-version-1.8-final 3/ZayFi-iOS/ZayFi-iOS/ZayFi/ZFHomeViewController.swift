
import UIKit
import MBProgressHUD
import Firebase

class ZFHomeViewController: UIViewController {
    
    var user: ZFUser = ZayFiManager.sharedInstance().user
    private var observer: NSObjectProtocol?
    var campaignAPIRequester: BEAdvertisementAPIRequester?
    var sessionAPIRequester: BESessionAPIRequester?
    var ctaInfo: ZFiOSCampaign?
    
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var dataUsageLabel: UILabel!
    @IBOutlet weak var dataUsageSubLabel: UILabel!
    @IBOutlet weak var sessionDurationLabel: UILabel!
    @IBOutlet weak var sessionDurationSubLabel: UILabel!
    @IBOutlet weak var savedDataLabel: UILabel!
    
    @IBOutlet weak var addHeight: NSLayoutConstraint!
    @IBOutlet weak var usageViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var addView: UIImageView!
    @IBOutlet weak var ctaButton: UIButton!
    
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var settingsIconBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHeight.constant =  0
        connectionStatusLabel.text = "UNKNOWN"
        dataUsageLabel.text = "0.0 GB"
        dataUsageSubLabel.text = "Left of 0 GB"
        sessionDurationLabel.text = "0.0"
        savedDataLabel.text = "0.0 GB"
        if let dataUsageText = ZFDefault.getDataFromDefault(.dataUsage) as? String, !dataUsageText.isEmpty {
            savedDataLabel.text = dataUsageText
        }
        
        //userNameLabel.text = "Username: \(user.email ?? "Username not available.")"
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.user = ZayFiManager.sharedInstance().user
            self?.nameLabel.text = "Hi, \(self?.user.name ?? "User")"
            self?.checkSessionStatus()
        }
        NotificationCenter.default.removeObserver(Notification.Name("PUSHRECIEVED"))
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationRecieved(notification:)), name: Notification.Name("PUSHRECIEVED"), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        MBProgressHUD.hide(for: view, animated: true)
        user = ZayFiManager.sharedInstance().user
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        nameLabel.text = "Hi, \(user.name ?? "User")"
        checkSessionStatus()
    }
    
    @objc func notificationRecieved(notification: NSNotification){
        checkSessionStatus()
    }
    
    private func populateAdvertisement() {
        self.campaignAPIRequester?.clear()
        self.campaignAPIRequester = BEAdvertisementAPIRequester.init(user: self.user) { [weak self] (completionStatus,responseData,error) in
            if let campDetails = responseData as? ZFCampaignAPIResponse {
                if let mediaURL = URL(string: campDetails.data?.homepageBanner ?? "") {
                    self?.downloadAddImage(from: mediaURL)
                }
                self?.ctaInfo = campDetails.data?.cta?.iosInfo
                self?.showCTAButton()
                self?.showFullPageAdd(from: campDetails.data?.contentUrl ?? "https://zaytech.ae")
            }
        }
        self.campaignAPIRequester?.actionType = .GetAdd
        self.campaignAPIRequester?.startAPIRequest()
        self.campaignAPIRequester?.session.finishTasksAndInvalidate()
    }
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
                                       
    private func downloadAddImage(from contentURL: URL) {
        getData(from: contentURL) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.addView.image = UIImage(data: data)
                self?.displayAdd()
            }
        }
    }
    
    private func showFullPageAdd(from contentURL: String) {
        guard ZFDefault.getDataFromDefault(.showCampaign) as? Bool == true else {
            return
        }
        
        DispatchQueue.main.async() { [weak self] in
            if let strongSelf = self {
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                Analytics.logEvent("DidShownFullPageAdd", parameters: [:])
                ZFDefault.setDataToDefault(value: false as Any, .showCampaign)
                
                let webViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFWebViewController") as! ZFWebViewController
                webViewController.webLink = contentURL
                webViewController.headerTitle = "ZayFi"
                strongSelf.navigationController?.pushViewController(webViewController, animated: false)
                
//                if let url = URL(string: contentURL) {
//                    UIApplication.shared.open(url)
//                }

            }
        }
    }
    
    private func displayAdd() {
        addHeight.constant = 190
    }
    
    private func showCTAButton() {
        DispatchQueue.main.async { [weak self] in
            guard let _ =  self?.user.userSession else {
                self?.ctaButton.isHidden = true
                return
            }
            if self?.ctaInfo == nil {
                if self?.user.userSession?.sessionStatus == 1 && self?.ctaInfo == nil {
                    self?.usageViewTopSpace.constant = 15
                }
                self?.ctaButton.isHidden = true
            } else {
                self?.usageViewTopSpace.constant = 74
                self?.ctaButton.isHidden = false
                self?.errorView.isHidden = true
                self?.ctaButton.setTitle(self?.ctaInfo?.btnText ?? "", for: .normal)
            }
        }
    }
    
    private func populateSessionInfo() {
        if let alloc = user.userSession?.usageAllocation {
            let totalMB = alloc.dataAllocated ?? 0
            let usedMB = alloc.dataBalance ?? 0
            if usedMB >= 1024 {
                let gbUsed: Double = Double(round(100 * Double(usedMB)/1024) / 100)
                dataUsageLabel.text = ("\(gbUsed) GB")
            } else {
                dataUsageLabel.text = ("\(usedMB) MB")
            }
            if totalMB >= 1024 {
                let gbAssigned = Double(round(1000 * Double(totalMB)/1024) / 1000)
                dataUsageSubLabel.text = ("Left of \(gbAssigned) GB")
            } else {
                dataUsageSubLabel.text = ("Left of \(totalMB) MB")
            }
        }
        
        if let history = user.userSession?.usageHistory {
            let usedTime = Int(history.usageTime ?? "0") ?? 0
            if usedTime > 0 {
                let (h,m,s) = ZFExtras.secondsToHoursMinutesSeconds(Int(usedTime))
                if h > 0 {
                    sessionDurationLabel.text = ("\(h)h:\(m)m")
                } else {
                    sessionDurationLabel.text = ("\(m)m:\(s)s")
                }
            }
            
            let savedData = Int(history.usageData ?? "0") ?? 0
            savedDataLabel.text = "0.0 GB"
            if savedData >= 1024 {
                let gbSaved = Double(round(1000 * Double(savedData)/1024) / 1000)
                savedDataLabel.text = ("\(gbSaved) GB")
                ZFDefault.setDataToDefault(value: ("\(gbSaved) GB"), .dataUsage)
            } else {
                savedDataLabel.text = ("\(savedData) MB")
                ZFDefault.setDataToDefault(value: ("\(savedData) MB"), .dataUsage)
            }
            ZFLog.debugLog(ZFDefault.getDataFromDefault(.dataUsage))
        }
    }
    
    private func checkSessionStatus() {
        bottomButton.isHidden = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        user.checkSessionStatus { session in
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    if let userSession = session {
                        strongSelf.user.userSession = session
                        if strongSelf.user.userSession!.sessionStatus == 1 {
                            if userSession.routerSession?.userName == strongSelf.user.phoneNumber {
                                strongSelf.connectionStatusLabel.text = "Connected"
                                strongSelf.bottomButton.isHidden = true
                                strongSelf.errorView.isHidden = true
                                strongSelf.getSessionInfo()
                            } else {
                                strongSelf.refreshLogin()
                            }
                        } else {
                            strongSelf.bottomButton.isHidden = false
                            strongSelf.connectionStatusLabel.text = "Not Connected"
                            strongSelf.bottomButton.setTitle("Refresh", for: .normal)
                            strongSelf.routerLogin()
                        }
                        ZFLog.debugLog("Status Response: \(String(describing: userSession))")
                    } else {
                        ZFLog.debugLog("Failed to call status API")
                        strongSelf.user.userSession = nil
                        strongSelf.bottomButton.isHidden = false
                        strongSelf.bottomButton.setTitle("Refresh", for: .normal)
                        strongSelf.connectionStatusLabel.text = "Not Connected"
                        strongSelf.errorView.isHidden = false
                        strongSelf.dataUsageLabel.text = "0.0 GB"
                        strongSelf.dataUsageSubLabel.text = "Left of 0 GB"
                        strongSelf.sessionDurationLabel.text = "0.0"
                    }
                    strongSelf.populateAdvertisement()
                }
            }
        }
    }
    
    private func refreshLogin() {
        self.sessionAPIRequester?.clear()
        self.sessionAPIRequester = BESessionAPIRequester.init(user: self.user) { [weak self] (completionStatus,responseData,error) in
            DispatchQueue.main.async { [weak self] in
                self?.checkSessionStatus()
            }
        }
        self.sessionAPIRequester?.actionType = .Logout
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    private func routerLogin() {
        user.routerLogin {  response, error in
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        strongSelf.user.userSession?.routerSession = response?.routerSession
                        MBProgressHUD.hide(for: strongSelf.view, animated: true)
                        if error == nil && response?.sessionStatus == 1 {
                            strongSelf.connectionStatusLabel.text = "Connected"
                            strongSelf.bottomButton.isHidden = true
                            strongSelf.errorView.isHidden = true
                            ZFLog.debugLog("Router Login Success with status code: 1 \n \(String(describing: response))")
                        } else {
                            strongSelf.errorView.isHidden = false
                            strongSelf.bottomButton.isHidden = false
                            strongSelf.connectionStatusLabel.text = "Not Connected"
                            strongSelf.bottomButton.setTitle("Refresh", for: .normal)
                            strongSelf.errorView.isHidden = false
                            ZFLog.debugLog("Router Login Failed")
                        }
                        strongSelf.getSessionInfo()
                    }
                }
        }
    }
    
    private func getSessionInfo() {
        user.getRouterSession { session, error in
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    if error == nil {
                        strongSelf.user.userSession?.usageAllocation = session?.data?.usageAllocation
                        strongSelf.user.userSession?.usageHistory = session?.data?.overallUsageHistory
                        ZFDefault.setDataToDefault(value: session?.data?.session?.sessionId ?? "", .sessionID)
                        strongSelf.populateSessionInfo()
                    }
                    ZayFiManager.sharedInstance().user.registerForPush { error in
                        ZFLog.debugLog("Registerd for push: \(error.debugDescription)")
                    }
                }
            }
        }
    }
    
    @IBAction func mainButtonAction(_ sender: Any) {
        checkSessionStatus()
    }
    
    @IBAction func showCTA(_ sender: Any) {
        if let url = URL(string: ctaInfo?.btnUrl ?? "https://zaytech.ae") {
            Analytics.logEvent("DidShownCampaign", parameters: [:])
            UIApplication.shared.open(url)
        }
    }
    @IBAction func showSettingsScreenBtnTapped(_ sender: UIButton) {
        
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFSettingsViewController") as! ZFSettingsViewController
            navigationController?.pushViewController(vc, animated: true)
    }
    
}
