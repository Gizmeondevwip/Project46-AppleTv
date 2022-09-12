//
//  UserActivationViewController.swift
//  BoondockDiscoverTv
//
//  Created by GIZMEON on 20/01/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class UserActivationViewController: UIViewController {
    @IBOutlet weak var EnterOtpLabel: UITextField!
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    var userDetails = [VideoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitAction(_ sender: Any) {
         let code = self.EnterOtpLabel.text
//        let deviceID =  UserDefaults.standard.string(forKey:"UDID")!
//        print(deviceID)
        var parameterDict: [String: String?] = [ : ]
        parameterDict["code"] = code
        ApiCommonClass.LoginFromMobile(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if let val = responseDictionary["error"] {
            DispatchQueue.main.async {
                commonClass.showAlert(viewController:self, messages: val as! String)

            }
          } else {
            
            DispatchQueue.main.async {
                self.userDetails = responseDictionary["Channels"] as! [VideoModel]

                UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                UserDefaults.standard.set("true", forKey: "login_status")
                UserDefaults.standard.set("false", forKey: "skiplogin_status")
              
                    let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
                    self.present(gotohomeView, animated: true, completion: nil)
               
            }
          }
        }
    }
}
