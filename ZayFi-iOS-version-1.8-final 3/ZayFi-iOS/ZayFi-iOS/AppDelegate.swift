//
//  AppDelegate.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 03/10/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        window?.overrideUserInterfaceStyle = .light
        getAppVersionDetails()
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            ZFDefault.setDataToDefault(value: true, .showCampaign)
        }
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                ZFLog.errorLog("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
       //let isAuthenticate =  ZFDefault.getDataFromDefault(.isAuthenticate)
       // if (isAuthenticate.count ?? 0 > 0 {
        if (ZFDefault.getDataFromDefault(.isAuthenticate) as? Bool == true){
            let homeController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ZFHomeNavigationController") as! UINavigationController
            window?.rootViewController = homeController
            window?.makeKeyAndVisible()
        }
        
        Analytics.logEvent("App Launched", parameters: [:])
        
        return true
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        ZFDefault.setDataToDefault(value: true, .showCampaign)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        ZFDefault.setDataToDefault(value: true, .showCampaign)
        NotificationCenter.default.post(name: Notification.Name("PUSHRECIEVED"), object: nil)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        ZFLog.debugLog("Push Token: \(deviceTokenString)")
        if let oldToken = ZFDefault.getDataFromDefault(.pushToken) as? String, deviceTokenString != oldToken {
            ZFDefault.setDataToDefault(value: deviceTokenString, .pushToken)
            if ZayFiManager.sharedInstance().user.email?.count ?? 0 > 0 {
                ZayFiManager.sharedInstance().user.registerForPush { error in
                    ZFLog.debugLog("Registerd for push: \(error.debugDescription)")
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ZFDefault.setDataToDefault(value: true, .showCampaign)
        NotificationCenter.default.post(name: Notification.Name("PUSHRECIEVED"), object: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        ZFLog.debugLog("Failed to register for Push: \(error.localizedDescription)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ZFLog.debugLog("Terminating")
        ZayFiManager.sharedInstance().user.logout { error in
            ZFLog.debugLog("Terminated")
        }
    }
    
    // MARK: - ForceUpdate
    
    var sessionAPIRequester: BESessionAPIRequester?
    func getAppVersionDetails() {
        self.sessionAPIRequester = BESessionAPIRequester.init(user: nil) { (completionStatus,responseData,error) in
            if let responseData = responseData as? ZFConfiguration {
                self.checkForAppUpdate(appVersionResponse : responseData)
            }
        }
        self.sessionAPIRequester?.actionType = .GetConfig
        self.sessionAPIRequester?.startAPIRequest()
        self.sessionAPIRequester?.session.finishTasksAndInvalidate()
    }
    
    func checkForAppUpdate(appVersionResponse : ZFConfiguration) {
        DispatchQueue.main.async {
            
            let appStoreLink: String = appVersionResponse.appStoreLink ?? "https://apps.apple.com/us/app/zayfi/id1602467323"
            
            let currentVersion = ZFExtras.appVersion
            let storeVersion = appVersionResponse.miniOSVersion
            
            //Compare App Versions
            let needToUpdate = storeVersion.compare(currentVersion, options: .numeric) == .orderedDescending
            
            if (needToUpdate) {
                let homeController = UIViewController()
                self.window?.rootViewController = homeController
                self.window?.makeKeyAndVisible()
                let alert = UIAlertController(title: "Confirmation", message: "You have to update the app to the minimum supported version. Please go to App store", preferredStyle: .alert)
                let updateAction = UIAlertAction(title: "Update", style: .default, handler:{ _ in
                    guard let url = URL(string: appStoreLink) else { return }
                    UIApplication.shared.open(url)
                })
                alert.addAction(updateAction)
                homeController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

