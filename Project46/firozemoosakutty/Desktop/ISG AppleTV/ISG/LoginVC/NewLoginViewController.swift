//
//  NewLoginViewController.swift
//  HappiAppleTV
//
//  Created by GIZMEON on 05/02/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
import Reachability
class NewLoginViewController: UIViewController,GuestRegisterDelegate {
    
    @IBOutlet weak var mainHeader: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var subheaderLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet {
            emailTextField.setBottomBorder()
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }}
    
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet {
            passwordTextField.setBottomBorder()
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }}
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
            loginButton.titleLabel?.textColor = .white
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.backgroundColor = .black
            signUpButton.titleLabel?.textColor = .white
        }
    }
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    
    
    
    @IBOutlet weak var activationView: UIView!
    @IBOutlet weak var codeTextfield: UITextField!{
        didSet {
            codeTextfield.setBottomBorder()
            codeTextfield.attributedPlaceholder = NSAttributedString(string: "Enter code here..",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
            submitButton.titleLabel?.textColor = .white
        }
    }
    let reachability = try! Reachability()
    var guestUserLogedIn = false
    var userDetails = [VideoModel]()
    weak var guestUserDelegate: videoPlayingDelegate!

    
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        submitButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
        mainHeader.textColor = ThemeManager.currentTheme().UIImageColor
       
        subheaderLabel.text = "\"Go to gethappi.tv/tv.\" \n Or \n Sign in?Create an account in your \n mobile app and select \n \"Tv Activation\" from menu."
        // handling back navigation33
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
       
    }
    //Exit from app
    @objc func menuButtonAction() {
        print("menu pressed")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let code = self.codeTextfield.text
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
    //Login action - validating email & password
    @IBAction func siginInAction(_ sender: Any) {
        signin()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "ForgotVc") as! ForgotPasswordViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    //Login action - validating email & password
    func signin(){
        if (commonClass.isValidEmail(email:emailTextField!.text! ) == 1) {
            commonClass.showAlert(viewController:self, messages: "Enter Email")
        } else if(commonClass.isValidEmail(email:emailTextField!.text! ) == 3) {
            commonClass.showAlert(viewController:self, messages: "Invalid Email")
        } else if (passwordTextField.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Password")
        }
//        else if (passwordTextField.text!.count < 6) {
//            commonClass.showAlert(viewController:self, messages: "Password should contain minimum of 6 characters")
//
//        }
        else {
            self.signInApiCalling()

//            reachability.whenReachable = { reachability in
//                if reachability.connection == .wifi {
//                    self.signInApiCalling()
//
//                    print("Reachable via WiFi")
//                } else {
//                    self.signInApiCalling()
//
//                    print("Reachable via Cellular")
//                }
//            }
//            reachability.whenUnreachable = { _ in
//                commonClass.showAlert(viewController:self, messages: "Network connection lost!")
//
//                print("Not reachable")
//            }
//
//            do {
//                try reachability.startNotifier()
//            } catch {
//                print("Unable to start notifier")
//            }
            
        }
    }
//Call to api "loginNew"
//@params useremail,password
    func signInApiCalling() {
        userDetails.removeAll()
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        guard let email =  self.emailTextField.text, let password = self.passwordTextField.text else {
            return
        }
       
        if UserDefaults.standard.string(forKey:"countryCode") != nil{
             parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        }
        else{
            parameterDict["country_code"] = "US"
        }
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
             parameterDict["device_id"] = device_id
           }
        if UserDefaults.standard.string(forKey:"IPAddress") != nil{
          if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
               parameterDict["ipaddress"] = ipAddress
           }
        }
        
        if emailTextField.text != nil{
            let trimmedString = emailTextField!.text!.trimmingCharacters(in: .whitespaces)
            parameterDict["user_email"] = trimmedString.lowercased()

        }
        if !password.isEmpty{
            let trimmedString = password.trimmingCharacters(in: .whitespaces)
            parameterDict["password"] = trimmedString
        }
        
        
        parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
        if UserDefaults.standard.string(forKey:"countryCode") != nil{
             parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        }
        else{
            parameterDict["country_code"] = " "
        }
//         parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
             parameterDict["device_id"] = device_id
           }
        if UserDefaults.standard.string(forKey:"IPAddress") != nil{
          if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
               parameterDict["ipaddress"] = ipAddress
           }
        }
        ApiCommonClass.Login (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if let errror = responseDictionary["error"] as? String {
                DispatchQueue.main.async {
                    
                    if responseDictionary["user_id"] == nil{
                        commonClass.showAlert(viewController: self, messages: errror )
                        commonClass.stopActivityIndicator(onViewController: self)
                        
                    }
                    else{
                        
                        
                        commonClass.stopActivityIndicator(onViewController: self)
//                        commonClass.showAlert(viewController:self, messages:  errror)
                        
                        
                        
                        UserDefaults.standard.set(email.lowercased(), forKey: "user_email")
                        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "otpVerification") as! OTPverificationViewController
                        gotohomeView.guestRegisterDelegates = self
                        Application.shared.isFromRegister = false
                        gotohomeView.userid = responseDictionary["user_id"]! as! String
                        
                        self.present(gotohomeView, animated: true, completion: nil)
                        
                        print(responseDictionary["user_id"])
                    }
                }
            } else {
                self.userDetails = responseDictionary["Channels"] as! [VideoModel]
                
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)

                    UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                    UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                    UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                    UserDefaults.standard.set("true", forKey: "login_status")
                    UserDefaults.standard.set("false", forKey: "skiplogin_status")
                    self.app_Install_Launch()
                    if self.guestUserLogedIn == true {
                        commonClass.stopActivityIndicator(onViewController: self)
                        Application.shared.guestRegister = true
                        self.getUserSubscription()
                    }
                    else {
                        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
                        self.present(gotohomeView, animated: true, completion: nil)
                    }
                    
                }
                
                
            }
        }
        
    }
    func app_Install_Launch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
 
      parameterDict["device_type"] = "apple-tv"
      if let longitude = UserDefaults.standard.string(forKey:"longitude") {
        parameterDict["longitude"] = longitude
      }
      if let latitude = UserDefaults.standard.string(forKey: "latitude"){
        parameterDict["latitude"] = latitude
      }
      if let country = UserDefaults.standard.string(forKey:"country"){
        parameterDict["country"] = country
      }
      if let city = UserDefaults.standard.string(forKey:"city"){
        parameterDict["city"] = city
      }
      if let userAgent = UserDefaults.standard.string(forKey:"userAgent"){
           parameterDict["ua"] = userAgent
         }
      if let IPAddress = UserDefaults.standard.string(forKey:"IPAddress") {
        parameterDict["ip_address"] = IPAddress
      }
     
      if let advertiser_id = UserDefaults.standard.string(forKey:"Idfa"){
        parameterDict["advertiser_id"] = advertiser_id
      }
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
         parameterDict["width"] =  String(format: "%.3f",UIScreen.main.bounds.width)
         parameterDict["height"] = String(format: "%.3f",UIScreen.main.bounds.height)
         parameterDict["device_make"] = "Apple"
        parameterDict["device_model"] = UserDefaults.standard.string(forKey:"deviceModel")
         if (UserDefaults.standard.string(forKey: "first_name") != nil){
          parameterDict["user_name"] = UserDefaults.standard.string(forKey: "first_name")
         }
      if let user_email = UserDefaults.standard.string(forKey: "user_email"){
       parameterDict["user_email"] = user_email
      }
       
      if let publisherid = UserDefaults.standard.string(forKey: "pubid") {
        parameterDict["publisherid"] = publisherid
      }
      
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
     
      if (UserDefaults.standard.string(forKey:"skiplogin_status") == "false") {
  //    if (UserDefaults.standard.string(forKey: "user_email") != nil){
  //     parameterDict["user_email"] = UserDefaults.standard.string(forKey: "user_email")
  //    }
  //
      if (UserDefaults.standard.string(forKey: "phone") != nil){
       parameterDict["user_contact_number"] = UserDefaults.standard.string(forKey: "phone")
      }
          
      }
        print("param for device api ",parameterDict)
      ApiCommonClass.analayticsAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            print("device api success")
          }
        }
      }
    }
   
    func getUserSubscription(){
        self.dismiss(animated: true, completion: nil)

        self.guestUserDelegate.guestUserLogin()
 
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
          super.didUpdateFocus(in: context, with: coordinator)
          coordinator.addCoordinatedAnimations({
              if  context.nextFocusedView  == self.emailTextField {
                  
                  if self.emailTextField.isFocused {
                      self.emailTextField.backgroundColor = focusedBgColor
                      self.emailTextField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                      
                      DispatchQueue.main.async {
                          self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                                         
                                                                                         attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                          
                      }
                  }
              } else if context.nextFocusedView  == self.passwordTextField  {
                  
                  if self.passwordTextField.isFocused {
                      self.passwordTextField.backgroundColor = focusedBgColor
                      self.passwordTextField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                      
                      DispatchQueue.main.async {
                          self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                                            
                                                                                            attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                          
                      }
                  }
                
              }
            else if context.nextFocusedView  == self.codeTextfield  {
                
                if self.codeTextfield.isFocused {
                    self.codeTextfield.backgroundColor = focusedBgColor
                    self.codeTextfield.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    
                    DispatchQueue.main.async {
                        self.codeTextfield.attributedPlaceholder = NSAttributedString(string: "Enter code here..",
                                                                                          
                                                                                          attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                        
                    }
                }
              
            }
              
               if context.previouslyFocusedView == self.emailTextField {
                  self.emailTextField.backgroundColor = UIColor.black
                  self.emailTextField.transform = .identity
                  DispatchQueue.main.async {
                      self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                                     attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                      
                  }
              } else  if context.previouslyFocusedView == self.passwordTextField {
                  self.passwordTextField.backgroundColor = UIColor.black
                  self.passwordTextField.transform = .identity
                  DispatchQueue.main.async {
                      self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                                        attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                      
                  }
              }
              else  if context.previouslyFocusedView == self.codeTextfield {
                  self.codeTextfield.backgroundColor = UIColor.black
                  self.codeTextfield.transform = .identity
                  DispatchQueue.main.async {
                      self.codeTextfield.attributedPlaceholder = NSAttributedString(string: "Enter code here..",
                                                                                        attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                      
                  }
              }
              
          }, completion: nil)
      }
    func didSelectGuestRegister() {
        
    }
    
    func didSelectSkipVerification() {
        
    }
    
}
