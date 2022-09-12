//
//  LogoutViewController.swift
//  ISG
//
//  Created by GIZMEON on 21/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class LogoutViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var privacyTextView: UITextView!{
        didSet{
            privacyTextView.isUserInteractionEnabled = true;
            privacyTextView.isScrollEnabled = true;
            privacyTextView.showsVerticalScrollIndicator = true;
            privacyTextView.bounces = true;
            privacyTextView.isSelectable = true


        }}
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var termsOfUseTextView:  UITextView!{
        didSet{
            termsOfUseTextView.isUserInteractionEnabled = true;
            termsOfUseTextView.isScrollEnabled = true;
            termsOfUseTextView.showsVerticalScrollIndicator = true;
            termsOfUseTextView.bounces = true;
            termsOfUseTextView.isSelectable = true
//            termsOfUseTextView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]

        }}
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailLabel.textColor = ThemeManager.currentTheme().UIImageColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(termsOfUseTapped(gesture:)))
        tap.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        termsOfUseTextView.addGestureRecognizer(tap)
        let tapPrivacy = UITapGestureRecognizer(target: self, action: #selector(tapped(gesture:)))
        tapPrivacy.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        privacyTextView.addGestureRecognizer(tapPrivacy)
        }
        // Do any additional setup after loading the view.    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        if UserDefaults.standard.string(forKey: "first_name") != nil{
            self.userName = ""
            self.userName = UserDefaults.standard.string(forKey: "first_name")!
            userNameLabel.text = self.userName.capitalized

        }
        if UserDefaults.standard.string(forKey: "skiplogin_status") == "true"{
            logoutButton.setTitle("Login with code", for: .normal)
            userEmailLabel.text = "Please login to HappiTV"
            
        }
        else{
            userEmailLabel.text = UserDefaults.standard.string(forKey: "user_email")
            logoutButton.setTitle("Logout of ISG", for: .normal)
        }
        logoutButton.layer.cornerRadius = 8

    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
          super.didUpdateFocus(in: context, with: coordinator)
          coordinator.addCoordinatedAnimations({
              if  context.nextFocusedView  == self.termsOfUseTextView {
                  
                  if self.termsOfUseTextView.isFocused {
                      self.termsOfUseTextView.backgroundColor = focusedBgColor
                      self.termsOfUseTextView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                  }
              }
               if context.previouslyFocusedView == self.termsOfUseTextView {
                  self.termsOfUseTextView.backgroundColor = UIColor.clear
                  self.termsOfUseTextView.transform = .identity
                  DispatchQueue.main.async {
                  }
              }
            if  context.nextFocusedView  == self.privacyTextView {
                
                if self.privacyTextView.isFocused {
                    self.privacyTextView.backgroundColor = focusedBgColor
                    self.privacyTextView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            }
             if context.previouslyFocusedView == self.privacyTextView {
                self.privacyTextView.backgroundColor = UIColor.clear
                self.privacyTextView.transform = .identity
                DispatchQueue.main.async {
                }
            }
              
          }, completion: nil)
      }
  
   
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.logout()
        
    }
    @objc func logout(){
        if UserDefaults.standard.string(forKey: "skiplogin_status") == "true"{
           
            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
            self.present(signupPageView, animated: true, completion: nil)
            
        }
        else{
            

            UserDefaults.standard.removeObject(forKey: "user_id")
            UserDefaults.standard.removeObject(forKey: "login_status")
            UserDefaults.standard.removeObject(forKey: "first_name")
            UserDefaults.standard.removeObject(forKey: "skiplogin_status")
            UserDefaults.standard.removeObject(forKey: "access_token")
            UserDefaults.standard.removeObject(forKey: "user_email")

            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
            self.present(signupPageView, animated: true, completion: nil)
            

        }
       
    }
    @objc func tapped(gesture: UITapGestureRecognizer) {
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "PrivacyVC") as! PrivacyPolicyViewController
        self.present(signupPageView, animated: true, completion: nil)
        }
    @objc func termsOfUseTapped(gesture: UITapGestureRecognizer) {
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUseVC") as! TermsOfUseViewController
        self.present(signupPageView, animated: true, completion: nil)
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
}
