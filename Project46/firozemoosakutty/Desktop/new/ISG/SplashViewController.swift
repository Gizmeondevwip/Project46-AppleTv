//
//  SplashViewController.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 14/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import Reachability
import AVFoundation

class SplashViewController: UIViewController,AVAudioPlayerDelegate {
    let reachability = try! Reachability()
    var audioPlayer = AVAudioPlayer()

    @IBOutlet weak var bannerLogo: UIImageView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        //declare this property where it won't go out of scope relative to your listener
        bannerWidth.constant = self.view.frame.width / 2
        bannerHeight.constant = self.view.frame.height / 3
        reachability.whenReachable = { reachability in
            if reachability.connection != .unavailable {
                print("Reachable via WiFi")
                
                if UserDefaults.standard.string(forKey:"countryCode") != nil {
                    self.getPubid()
                    
                }
                else{
                    print("call to ip and location")
                    self.getIPAddressandlocation()
                }
            }
        }
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")
            
            print("Not reachable")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        print("viewWillAppear")
    }
    func getIPAddressandlocation()  {
        print("get to ip and location")
        
        ApiCommonClass.getIpandlocation { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                UserDefaults.standard.set("103.71.169.219", forKey: "IPAddress")
                UserDefaults.standard.set("IN", forKey: "countryCode")
            } else{
                DispatchQueue.main.async {
                    self.getPubid()
                    
                }
            }
        }
        
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")//It is working now! printed "finished"!
         self.getPubid()
        
    }
    func playSound(file:String, ext:String) -> Void {
               do {
                   let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: file, ofType: ext)!)
                   audioPlayer = try AVAudioPlayer(contentsOf: url)
                   audioPlayer.prepareToPlay()
                   audioPlayer.play()
                audioPlayer.delegate = self

               } catch let error {
                   NSLog(error.localizedDescription)
               }
     
           }
    
    
    // check registration flag
    
    func getPubid() {
        print("getpubid")
        ApiCommonClass.getPubid1 { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                commonClass.showAlert(viewController:self, messages: "Server error")
            } else {
                DispatchQueue.main.async {
                    if UserDefaults.standard.string(forKey:"user_id") != nil {
                        if UserDefaults.standard.string(forKey: "registration_mandatory_flag") == "1"{
                            if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                                self.logOutdata()
                            }
                            else{
                                self.checkSubscription()
                            }

                        }
                        else{
                            self.checkSubscription()
                        }
                    } else {
                        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
                        self.present(signupPageView, animated: true, completion: nil)                    }

//                        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
//                        self.present(signupPageView, animated: true, completion: nil)                    }

                }
            }
            
        }
    }
    func skipLogin() {
      let deviceID =  UserDefaults.standard.string(forKey:"UDID")!
      print(deviceID)
      var parameterDict: [String: String?] = [ : ]
      parameterDict["device_id"] = deviceID
      ApiCommonClass.getGustUserId(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if let val = responseDictionary["error"] {
          DispatchQueue.main.async {
            
          }
        } else {
          if let val = responseDictionary["Channels"] {
            DispatchQueue.main.async {
              UserDefaults.standard.set(self.getDateAfterTenDays(), forKey: "guestloginafter10_date")
              UserDefaults.standard.set("true", forKey: "login_status")
              UserDefaults.standard.set("true", forKey: "skiplogin_status")
              UserDefaults.standard.set(responseDictionary["Channels"], forKey: "user_id")
              UserDefaults.standard.set("Guest User", forKey: "first_name")
//              self.guestUserLogedIn = true
              Application.shared.userSubscriptionStatus = false
                let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
                self.present(gotohomeView, animated: true, completion: nil)
              
              
            }
          }
        }
      }
    }
    func getDateAfterTenDays() -> String {
      let dateAftrTenDays =  (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy"
      let date = formatter.string(from: dateAftrTenDays)
      return date
    }
    func checkSubscription(){
        if UserDefaults.standard.string(forKey: "subscription_mandatory_flag") == "1"{
            if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
                self.logOutdata()
            }
            else{
                getToken()
            }
        }
        else{
            getToken()
        }
    }
   
    func getToken() {
        
        ApiCommonClass.getToken { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                commonClass.showAlert(viewController:self, messages: "Server error")
            } else {
                DispatchQueue.main.async {
                    if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
                        if  UserDefaults.standard.string(forKey:"login_status") == nil {
                            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                            self.present(signupPageView, animated: true, completion: nil)
                        } else {
                            
                            let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
                            self.present(gotohomeView, animated: true, completion: nil)
                        }
                    } else {
                        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
                        self.present(gotohomeView, animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    func logOutdata() {
        var parameterDict: [String: String?] = [ : ]

        if let deviceid = UserDefaults.standard.string(forKey:"UDID") {
            parameterDict["device_id"] = deviceid
        }
        if let user_id = UserDefaults.standard.string(forKey:"user_id") {
            parameterDict["user_id"] = user_id
        }
        if let pubid = UserDefaults.standard.string(forKey:"pubid") {
            parameterDict["pubid"] = pubid
        }
        if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
            parameterDict["ipaddress"] = ipAddress
        }
        ApiCommonClass.logOutAction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (result) -> () in
            print(result)
            if result {
                UserDefaults.standard.removeObject(forKey: "user_id")
                UserDefaults.standard.removeObject(forKey: "login_status")
                UserDefaults.standard.removeObject(forKey: "first_name")
                UserDefaults.standard.removeObject(forKey: "skiplogin_status")
                UserDefaults.standard.removeObject(forKey: "access_token")
                Application.shared.userSubscriptionsArray.removeAll()
                let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                self.present(signupPageView, animated: true, completion: nil)
                
            } else {
//                WarningDisplayViewController().customAlert(viewController:self, messages: "Some error occured..Please try again later")
            }
        }

    }
    
    
}
//func getPubid(){
//    ApiCommonClass.getPubId().onSuccess { appUser in
//        if UserDefaults.standard.string(forKey:"user_id") != nil {
//            if UserDefaults.standard.string(forKey: "registration_mandatory_flag") == "1"{
//                if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
//                    self.logOutdata()
//                }
//                else{
//                    self.checkSubscription()
//                }
//
//            }
//            else{
//                self.checkSubscription()
//            }
//        } else {
//            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
//            self.present(signupPageView, animated: true, completion: nil)
//        }
//
//    }
//
//
//
//}
