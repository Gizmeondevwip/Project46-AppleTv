//
//  LoginViewController.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 15/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import Reachability
protocol videoPlayingDelegate:class { // delegate for playing video after login from guest user
    func guestUserLogin()
}
class LoginViewController: UIViewController, GuestRegisterDelegate {
   
    
    
    
    let reachability = try! Reachability()
    var guestUserLogedIn = false
    var userDetails = [VideoModel]()
    weak var guestUserDelegate: videoPlayingDelegate!

    
    @IBOutlet weak var signInAction: UIButton!
    
    @IBOutlet weak var skipLoginButton: UIButton!
    
    @IBOutlet weak var emailTextfield: UITextField!{
        didSet {
            emailTextfield.setBottomBorder()
            emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.backgroundColor: UIColor.white])
        }}
    
    @IBOutlet weak var passwordTextfield: UITextField!{
        didSet {
            passwordTextfield.setBottomBorder()
            emailTextfield.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }}

    override func viewDidLoad() {
        super.viewDidLoad()
        // handling back navigation
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
          
        // Do any additional setup after loading the view.
    }
    //Exit from app
    @objc func menuButtonAction() {
        print("menu pressed")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
   //Signup action - goto signup page
    @IBAction func signUpAction(_ sender: Any) {
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    //Login action - validating email & password
    func signin(){
        if (commonClass.isValidEmail(email:emailTextfield!.text! ) == 1) {
            commonClass.showAlert(viewController:self, messages: "Enter Email")
        } else if(commonClass.isValidEmail(email:emailTextfield!.text! ) == 3) {
            commonClass.showAlert(viewController:self, messages: "Invalid Email")
        } else if (passwordTextfield.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Password")
        }
        else if (passwordTextfield.text!.count < 6) {
            commonClass.showAlert(viewController:self, messages: "Password should contain minimum of 6 characters")
            
        }else {
            
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    self.signInApiCalling()

                    print("Reachable via WiFi")
                } else {
                    self.signInApiCalling()

                    print("Reachable via Cellular")
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
    }
//Call to api "loginNew"
//@params useremail,password
    func signInApiCalling() {
        userDetails.removeAll()
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        guard let email =  self.emailTextfield.text, let password = self.passwordTextfield.text else {
            return
        }
        parameterDict["user_email"] = email
        parameterDict["password"] = password
        parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
        ApiCommonClass.Login (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if let errror = responseDictionary["error"] as? String {
                DispatchQueue.main.async {
                    
                    if responseDictionary["user_id"] == nil{
                        commonClass.stopActivityIndicator(onViewController: self)
                        
                    }
                    else{
                        
                        
                        commonClass.stopActivityIndicator(onViewController: self)
                        commonClass.showAlert(viewController:self, messages:  errror)
                        
                        
                        
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
                commonClass.stopActivityIndicator(onViewController: self)
                self.userDetails = responseDictionary["Channels"] as! [VideoModel]
                
                DispatchQueue.main.async {
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
    
    @IBAction func signInButton(_ sender: Any) {
         signin()
    }
        
    @IBAction func forgotAction(_ sender: Any) {
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "ForgotVc") as! ForgotPasswordViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    
    @IBAction func skipLoginAction(_ sender: Any) {
    
        //        if  reachability.connection != .none {
          skipLogin()
//        } else {
//          AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
//        }
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
              self.guestUserLogedIn = true
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
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
          super.didUpdateFocus(in: context, with: coordinator)
          coordinator.addCoordinatedAnimations({
              if  context.nextFocusedView  == self.emailTextfield {
                  
                  if self.emailTextfield.isFocused {
                      self.emailTextfield.backgroundColor = focusedBgColor
                      self.emailTextfield.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                      
                      DispatchQueue.main.async {
                          self.emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                                         
                                                                                         attributes:  [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
                          
                      }
                  }
              } else  {
                  
                  if self.passwordTextfield.isFocused {
                      self.passwordTextfield.backgroundColor = focusedBgColor
                      self.passwordTextfield.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                      
                      DispatchQueue.main.async {
                          self.passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                                            
                                                                                            attributes:  [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
                          
                      }
                  }
              }
              
               if context.previouslyFocusedView == self.emailTextfield {
                  self.emailTextfield.backgroundColor = UIColor.black
                  self.emailTextfield.transform = .identity
                  DispatchQueue.main.async {
                      self.emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                                     attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                      
                  }
              } else  if context.previouslyFocusedView == self.passwordTextfield {
                  self.passwordTextfield.backgroundColor = UIColor.black
                  self.passwordTextfield.transform = .identity
                  DispatchQueue.main.async {
                      self.passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password",
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
