//
//  OtpVerificationViewController.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 21/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
import Reachability
protocol RegisterMenuDelegate: class {
    func didSelectRegister()
    func didSelectRegisterSkip()
}
protocol GuestRegisterDelegate: class {
    func didSelectGuestRegister()
    func didSelectSkipVerification()
}
class OTPverificationViewController: UIViewController,UITextFieldDelegate{
  
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.textColor = ThemeManager.currentTheme().UIImageColor
        }
    }
   
    @IBOutlet weak var otpTextField: UITextField!{
        didSet {
            otpTextField.textColor = .white
            otpTextField.attributedPlaceholder = NSAttributedString(string: "Enter otp",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }}
    
    @IBOutlet weak var resendOtpLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
            self.submitButton.setTitleColor(.white, for: .normal)
        }
    
    }
    
    @IBOutlet weak var resendButton: UIButton!{
    didSet{
        resendButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
        self.resendButton.setTitleColor(.white, for: .normal)
    }
}
    var countTimer:Timer!
    var counter = 60
    var fromRegister = Bool()
    var accesstoken = String()
    var userDetails = [userModel]()


    weak var registerdelegates : RegisterMenuDelegate?
    weak var guestRegisterDelegates : GuestRegisterDelegate?

    override func viewDidLoad() {
      super.viewDidLoad()
        view.backgroundColor = .black
        if UserDefaults.standard.string(forKey: "user_email") != nil
         {
            self.emailLabel.text = "Enter the 6-digit code sent to \(UserDefaults.standard.string(forKey: "user_email") ?? "hjhj")"

         }
        self.submitButton.layer.cornerRadius = 5
        self.submitButton.clipsToBounds = true
        
        self.resendButton.isHidden = true
        self.resendOtpLabel.isHidden = true
        self.submitButton.isEnabled = true
       
        // Do any additional setup after loading the view.
        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                             target: self,
                                             selector: #selector(self.changeTitle),
                                             userInfo: nil,
                                             repeats: true)
//        let menuPressRecognizer = UITapGestureRecognizer()
//        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
//        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
//        self.view.addGestureRecognizer(menuPressRecognizer)
        
    }
    //Exit back
    @objc func menuButtonAction() {
        print("menu pressed")
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

     

    }
    @objc func changeTitle() {
     if counter != 0 {
       self.resendOtpLabel.isHidden = false
       self.resendButton.isHidden = true
        resendOtpLabel.text =  "Resend otp in \(counter)"
        submitButton.isHidden = false
        submitButton.isEnabled = true
       counter -= 1
     } else {
       countTimer.invalidate()
        resendOtpLabel.text = "resend otp in 60"
       self.resendOtpLabel.isHidden = true
       self.resendButton.isHidden = false
        submitButton.isHidden = true
        submitButton.isEnabled = false
     }
   }
    var userid = String()

   
    func didCallRegisterApi() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: {
                if Application.shared.isFromRegister {
                    self.registerdelegates?.didSelectRegister()
                } else {
                    self.guestRegisterDelegates?.didSelectGuestRegister()
                }
            })
        })
    }
    func didClickSkipRegisterd(){
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: {
                if Application.shared.isFromRegister {
                    self.registerdelegates?.didSelectRegisterSkip()
                } else {
                    self.guestRegisterDelegates?.didSelectSkipVerification()
                }
            })
        })
    }
    func gotoHomeAferVerification(){
        UIView.animate(withDuration: 0.15, animations: {
                  self.view.backgroundColor=UIColor.clear
              }, completion:{ _ in
                  self.dismiss(animated: true, completion: {
//                    navigationController?.popViewController(animated: false)
                           Application.shared.guestRegister = false
                           self.gotoHome1()
                  })
              })
       
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
      func gotoHome1(){
//            self.dismiss(animated: true, completion: nil)
    //        getUserSubscription()
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
        self.present(gotohomeView, animated: true, completion: nil)
        }
    var fromLogin = false
    func gotoHome(){
        if fromRegister{
            UserDefaults.standard.set("1", forKey: "verifiedNumber")
            commonClass.stopActivityIndicator(onViewController: self)
           gotoHomeAferVerification()
            
        }
        else{
            UserDefaults.standard.set("1", forKey: "verifiedNumber")
            commonClass.stopActivityIndicator(onViewController: self)
            
           gotoHomeAferVerification()
        }
        
    
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    @IBAction func verifyAction(_ sender: Any) {
//        self.submitButton.isEnabled = true
        otpTextField.resignFirstResponder()
        if otpTextField.text!.count < 6 {
            commonClass.showAlert(viewController: self, messages: "Please enter a valid otp.")
            self.otpTextField.text?.removeAll()
        }
         if otpTextField.text?.count == 6 {
  //            CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
              let verificationCode = otpTextField.text
          var parameterDict: [String: String?] = [ : ]
           parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
          parameterDict["user_id"] = self.userid
          parameterDict["otp"] = verificationCode
                 let user_id = self.userid
                 let country_code = UserDefaults.standard.string(forKey:"countryCode")!
                 let pubid = UserDefaults.standard.string(forKey:"pubid")!
                 let device_type = "ios-phone"
                 let dev_id = UserDefaults.standard.string(forKey:"UDID")!
                 let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
                 let channelid = UserDefaults.standard.string(forKey:"channelid")!
                 let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
  //        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
           if UserDefaults.standard.string(forKey:"access_token") == nil {
              self.accesstoken = " "
              
                   }
           else{
              self.accesstoken = UserDefaults.standard.string(forKey:"access_token")!
          }
          let otpVerification = ApiRESTUrlString().verifyOtp(parameterDictionary: parameterDict as? Dictionary<String, String>)
          
          ApiCallManager.apiCallREST(mainUrl: otpVerification!, httpMethod: "GET", headers: ["access-token": self.accesstoken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: parameterDict as? Data) { (responseDictionary: Dictionary) in
                  var channelResponseArray = [userModel]()
                  var channelResponse = Dictionary<String, AnyObject>()
                  guard let status: Int = responseDictionary["success"] as? Int else { return }
                  if status == 0{
                              print("incorrect otp")
                      DispatchQueue.main.async {
                        commonClass.stopActivityIndicator(onViewController: self)//
                        commonClass.showAlert(viewController: self, messages: "Incorrect OTP")
                          self.otpTextField.text?.removeAll()
                      }
                      
                  }
              if status == 1 {// Create a user!
                  let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                  for videoItem in dataArray {
                      let JSON: NSDictionary = videoItem as NSDictionary
                      let videoModel: userModel = userModel.from(JSON)! // This is a 'User?'
                      channelResponseArray.append(videoModel)
                      
                  }
                  
                  channelResponse["Channels"]=channelResponseArray as AnyObject
                  self.userDetails = channelResponse["Channels"] as! [userModel]
                  if self.userDetails.count != 0 {
                      print(self.userDetails[0])
                      DispatchQueue.main.async {
                          UserDefaults.standard.string(forKey: "first_name")
                          UserDefaults.standard.set(self.userDetails[0].phone, forKey: "user_contact_number")
                          UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                          UserDefaults.standard.set("true", forKey: "login_status")
                          UserDefaults.standard.set("false", forKey: "skiplogin_status")
                          UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                          UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "first_name")
                        self.app_Install_Launch()
                        self.gotoHome1()
                      }
                      
                  }
                  
              } else {
                  channelResponse["error"]=responseDictionary["message"]
              }
              
          }

       
          
         } else {
         
            self.otpTextField.layer.shadowColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func resendOtp(_ sender: Any) {
        self.submitButton.isEnabled = true
          let UDID = UIDevice.current.identifierForVendor?.uuidString
          let udid = UDID
       
        var parameterDict: [String: String?] = [ : ]
          let user_id = self.userid
         let country_code = UserDefaults.standard.string(forKey:"countryCode")!
         let pubid = UserDefaults.standard.string(forKey:"pubid")!
         let device_type = "ios-phone"
         let dev_id = UserDefaults.standard.string(forKey:"UDID")!
         let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
         let channelid = UserDefaults.standard.string(forKey:"channelid")!
         let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
              print("parameterDictionary",parameterDict)
                  

          let otpVerification = ApiRESTUrlString().resendOtp(parameterDictionary: parameterDict as? Dictionary<String, String>)
          ApiCallManager.apiCallREST(mainUrl: otpVerification!, httpMethod: "GET", headers: ["access-token": " ","uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
  //                 if let getTokenApi = ApiRESTUrlString().getFreeShows(parameterDictionary: parameterDict as? Dictionary<String, String>) {
                  guard let status = responseDictionary["success"] as? Bool  else {
                    return
                  }
                  if status == true{
                      print("otp send to email")
                  }
                  DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.otpTextField.text?.removeAll()
                      self.counter = 60
                                self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                                       target: self,
                                                                       selector: #selector(self.changeTitle),
                                                                       userInfo: nil,
                                                                       repeats: true)
                             
                                self.resendButton.isHidden = true
                                self.resendOtpLabel.isHidden = false
                  }
                  
                  
                    
                }
              
//     else {
//          AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
//        }

    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
          super.didUpdateFocus(in: context, with: coordinator)
          coordinator.addCoordinatedAnimations({
              if  context.nextFocusedView  == self.otpTextField {
                  
                  if self.otpTextField.isFocused {
                      self.otpTextField.backgroundColor = focusedBgColor
                      self.otpTextField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                      
                      DispatchQueue.main.async {
                          self.otpTextField.attributedPlaceholder = NSAttributedString(string: "Enter otp",
                                                                                         
                                                                                         attributes:  [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
                          
                      }
                  }
              }
           
              
               if context.previouslyFocusedView == self.otpTextField {
                  self.otpTextField.backgroundColor = UIColor.black
                  self.otpTextField.transform = .identity
                  DispatchQueue.main.async {
                      self.otpTextField.attributedPlaceholder = NSAttributedString(string: "Enter otp",
                                                                                     attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                      
                  }
              }
              
          }, completion: nil)
      }
}
