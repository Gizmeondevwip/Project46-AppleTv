//
//  SignUpViewController.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 14/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var EmailTextfieldWidth: NSLayoutConstraint!
    @IBOutlet weak var NameTextfieldWidth: NSLayoutConstraint!
    @IBOutlet weak var PasswordTextfieldWidth: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var nameTextfield: UITextField!{
        didSet {
//            nameTextfield.setBottomBorder()
            nameTextfield.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
        }}
    
    @IBOutlet weak var emailTextfield: UITextField!{
        didSet {
//            emailTextfield.setBottomBorder()
            emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }}
    
    @IBOutlet weak var passwordTextfield: UITextField!{
        didSet {
//            passwordTextfield.setBottomBorder()
            passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }}
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.backgroundColor = bgColor
        self.updateFocusIfNeeded()
        Application.shared.country_code = "US"
        signUpButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
     
        self.EmailTextfieldWidth.constant = view.frame.width / 3
        self.NameTextfieldWidth.constant = view.frame.width / 3
        self.PasswordTextfieldWidth.constant = view.frame.width / 3
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
        // Do any additional setup after loading the view.
    }
    //Exit back
    @objc func menuButtonAction() {
        print("menu pressed")
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if (nameTextfield.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Name")
        }
      else if  nameTextfield.text?.rangeOfCharacter(from: lettersAndSpacesCharacterSet) != nil {
        commonClass.showAlert(viewController:self, messages: "No special character allowed for user name")
       }
      else if nameTextfield.text!.isReallyEmpty || nameTextfield.text == "              " {
        commonClass.showAlert(viewController:self, messages: "User name must start with letter")
      }
        else if (commonClass.isValidEmail(email:emailTextfield!.text! ) == 1) {
            commonClass.showAlert(viewController:self, messages: "Enter Email")
        } else if(commonClass.isValidEmail(email:emailTextfield!.text! ) == 3) {
            commonClass.showAlert(viewController:self, messages: "Invalid Email")
        } else if (passwordTextfield.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Password")
        }
        else if (passwordTextfield.text!.count < 6) {
            commonClass.showAlert(viewController:self, messages: "Password should contain minimum of 6 characters")
        }else {
            register()
        }
    }
    var userId = String()
    let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted

    func register() {
        let UDID = UIDevice.current.identifierForVendor?.uuidString
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        var parameterDict: [String: String?] = [ : ]
        
        guard let email = self.emailTextfield.text, let password = self.passwordTextfield.text,let udid = UDID,let name = self.nameTextfield.text  else {
            return
        }
        if self.emailTextfield.text != nil{
            let trimmedString = self.emailTextfield!.text!.trimmingCharacters(in: .whitespaces)
            parameterDict["user_email"] = trimmedString.lowercased()
            UserDefaults.standard.set(parameterDict["user_email"] as Any?, forKey: "user_email")


        }
        if !password.isEmpty{
            let trimmedString = password.trimmingCharacters(in: .whitespaces)
            parameterDict["password"] = trimmedString
        }
//            parameterDict["user_email"] = email.lowercased()
//            parameterDict["password"] = password
        parameterDict["first_name"] = name
        parameterDict["last_name"] = ""

        
        if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
            parameterDict["ipaddress"] = ipAddress
        }
        

       
       parameterDict["apple_id"] = "0"

       
       
      
            parameterDict["facebook_id"] = "0"
            
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
     
        parameterDict["login_type"] = "gmail-login"
        parameterDict["verified"] = UserDefaults.standard.string(forKey: "verifiedNumber")
        parameterDict["c_code"] = ""
        if let longitude = UserDefaults.standard.string(forKey:"longitude") {
          parameterDict["longitude"] = longitude
        }
        if let latitude = UserDefaults.standard.string(forKey: "latitude"){
          parameterDict["latitude"] = latitude
        }
        if let country = UserDefaults.standard.string(forKey:"country"){
          parameterDict["country"] = country
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(parameterDict)
        print("parameterDictionary",parameterDict)
        ApiCallManager.apiCallREST(mainUrl: RegisterApi, httpMethod: "POST", headers: ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: data) { (responseDictionary: Dictionary) in
            
            var channelResponse = Dictionary<String, AnyObject>()
            print("enter to registration ")
           guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 0{
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController: self, messages: responseDictionary["message"] as! String)
                    
                }
            }
            else if status == 1 {
                DispatchQueue.main.async {
                    let dataArray = responseDictionary["user_id"] as AnyObject
                    let  id = dataArray
                    print(id)
                    let x = id as! Int
                    self.userId = String(x)
                    commonClass.stopActivityIndicator(onViewController: self)
                    let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "otpVerification") as! OTPverificationViewController
                    gotohomeView.registerdelegates = self
                    gotohomeView.userid = self.userId
                    Application.shared.isFromRegister = true
                    
                    self.present(gotohomeView, animated: true, completion: nil)
                }
                
                
            }
            else if status == 2{
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController: self, messages: "Already registered user")
                    
                }
            }
            else {
                channelResponse["error"]=responseDictionary["message"]
            }
            
        }
        
    }
    

        
        
   
    @IBAction func alreadyOnAdventure(_ sender: Any) {
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
        self.present(signupPageView, animated: true, completion: nil) 
        
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations({
            if  context.nextFocusedView  == self.nameTextfield {
                if self.nameTextfield.isFocused {
                    self.nameTextfield.backgroundColor = focusedBgColor
                    self.nameTextfield.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    
                    DispatchQueue.main.async {
                        self.nameTextfield.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                                      
                                                                                      attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                        
                    }
                }
            } else if  context.nextFocusedView  == self.emailTextfield {
                
                if self.emailTextfield.isFocused {
                    self.emailTextfield.backgroundColor = focusedBgColor
                    self.emailTextfield.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    
                    DispatchQueue.main.async {
                        self.emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                                       
                                                                                       attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                        
                    }
                }
            } else  {
                
                if self.passwordTextfield.isFocused {
                    self.passwordTextfield.backgroundColor = focusedBgColor
                    self.passwordTextfield.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    
                    DispatchQueue.main.async {
                        self.passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                                          
                                                                                          attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                        
                    }
                }
            }
            
            
            if context.previouslyFocusedView == self.nameTextfield {
                self.nameTextfield.backgroundColor = UIColor.black
                self.nameTextfield.transform = .identity
                DispatchQueue.main.async {
                    self.nameTextfield.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                                  attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                    
                }
            } else if context.previouslyFocusedView == self.emailTextfield {
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
    
    //        ApiCommonClass.Register(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
    //            print(responseDictionary)
    //            if responseDictionary["error"] != nil {
    //                DispatchQueue.main.async {
    //                    commonClass.showAlert(viewController:self, messages:  responseDictionary["error"] as! String)
    //                    commonClass.stopActivityIndicator(onViewController: self)
    //                }
    //            } else {
    //                DispatchQueue.main.async {
    //                    if let username = responseDictionary["first_name"] as? String {
    //                        UserDefaults.standard.set(username, forKey: "first_name")
    //                    }
    //                    if let userId = responseDictionary["user_id"] as? Int {
    //                        UserDefaults.standard.set(userId, forKey: "user_id")
    //                    }
    //                    UserDefaults.standard.set("true", forKey: "login_status")
    //                    UserDefaults.standard.set("false", forKey: "skiplogin_status")
    //                    commonClass.stopActivityIndicator(onViewController: self)
    //                }
    //            }
    //        }
    func gotoHome(){
//        self.dismiss()
//        getUserSubscription()
//        self.dismiss(animated: true, completion: nil)
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//                                        delegate!.loadTabbar()
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
        present(gotohomeView, animated: true, completion: nil)
       
    }
}
extension SignUpViewController: RegisterMenuDelegate {
    func didSelectRegisterSkip() {
        
        Application.shared.guestRegister = true
        self.gotoHome()
    }
    func didSelectRegister(){
        navigationController?.popViewController(animated: false)
        Application.shared.guestRegister = false
        self.gotoHome()
    }
}
extension String {
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}


