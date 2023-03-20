//
//  ZFDebugViewController.swift
//  ZayFi-iOS
//
//  Created by SayOne Technologies on 03/01/22.
//

import UIKit

class ZFDebugViewController: UIViewController {
    
    @IBOutlet weak var debugTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //ZFLog.debugLog(ZFdebugLogs)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ZFDebugViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZFdebugLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//ZFDebugCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZFDebugCell") as! ZFDebugCell
        cell.debuTextLabel?.text = ZFdebugLogs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = ZFdebugLogs[indexPath.row]
    }
    
    
}
