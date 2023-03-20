//
//  ZFWebViewController.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 22/12/21.
//

import UIKit
import WebKit
import MBProgressHUD

class ZFWebViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var headerTitle = String()
    var webLink = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setTitle("", for: .normal)
        headerLabel.text = headerTitle
        
        webView.navigationDelegate = self
        
//        let contentController = WKUserContentController()
//          contentController.add(self, name: "callback")
//
//          let config = WKWebViewConfiguration()
//          config.userContentController = contentController
//
//        let webview = WKWebView(frame: webView.frame, configuration: config)
//        self.view.addSubview(webview)
//        let link1 = "https://dashboard.zaytech.ae/ad-campaign/content?ut_token=a14720d85fb9beb783fb54e75005efd3"
        
        let urlreq = URLRequest(url: URL(string: webLink)!)
        webView.load(urlreq)
        
//        webView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension ZFWebViewController: WKNavigationDelegate {
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == WKNavigationType.linkActivated {
//            print("link")
//
//            decisionHandler(WKNavigationActionPolicy.cancel)
//            return
//        }
//        print("no link")
//        if((webView.url?.absoluteString.contains("https://secure5.arcot.com/vpas/admin/"))! && navigationAction.navigationType.rawValue == -1){
//            print("user click the button")
//        }
//        decisionHandler(WKNavigationActionPolicy.allow)
//
//    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
//
//extension ZFWebViewController: WKScriptMessageHandler {
//  
//  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//    //This function handles the events coming from javascript. We'll configure the javascript side of this later.
//    //We can access properties through the message body, like this:
//    guard let response = message.body as? String else { return }
//    print(response)
//  }
//  
//}
