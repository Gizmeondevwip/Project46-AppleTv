//
//  ForgotPasswordVC.swift
//  HappiAppleTV
//
//  Created by GIZMEON on 11/02/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class ForgotPasswordViewController: UIViewController,UITextFieldDelegate  {
    
    @IBOutlet weak var HeaderLabel: UILabel!{
        didSet{
            HeaderLabel.textColor = .white
        }
    }
    @IBOutlet weak var SubHeaderLabel: UILabel!{
        didSet{
            SubHeaderLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var EmailTextField: UITextField!{
        didSet {
            EmailTextField.setBottomBorder()
            EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }}
    @IBOutlet weak var SubmitButton: UIButton!{
        didSet{
            SubmitButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
            SubmitButton.titleLabel?.textColor = .white
        }
    }
    @IBOutlet weak var BackButton: UIButton!{
    didSet{
        BackButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
        BackButton.titleLabel?.textColor = .white
    }
}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        HeaderLabel.text = "Forgot your Password?"
        SubHeaderLabel.text = "Please enter your email adress to recieve reset password link"
        SubmitButton.setTitle("SUBMIT", for: .normal)
        BackButton.setTitle("Return to login", for: .normal)
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
    }
    //Exit back
    @objc func menuButtonAction() {
        print("menu pressed")
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if (commonClass.isValidEmail(email:EmailTextField!.text! ) == 1) {
            commonClass.showAlert(viewController:self, messages: "Enter Email")
        } else if(commonClass.isValidEmail(email:EmailTextField!.text! ) == 3) {
            commonClass.showAlert(viewController:self, messages: "Invalid Email")
        }
        else{
            forgotPassword()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "NewLoginVC") as! NewLoginViewController
        self.present(gotohomeView, animated: true, completion: nil)
    }
    
    
    func forgotPassword() {
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        guard let email = EmailTextField.text else {
            return
        }
        parameterDict["user_email"] = email.lowercased()
        parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
        print(parameterDict)
        ApiCommonClass.ForgotPassword (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController: self, messages: "This email id is not registered with HappiTV")
                }
            } else {

                DispatchQueue.main.async {
                    let message = responseDictionary["Channels"] as! String
                    print(message)
                    if message != "Invalid user" {
                        commonClass.stopActivityIndicator(onViewController: self)
                        commonClass.showAlert(viewController: self, messages: "Please check your mail")
                        

                    }else {
                        commonClass.stopActivityIndicator(onViewController: self)
                        commonClass.showAlert(viewController: self, messages: "This email id is not registered with HappiTV")

                    }
                }
            }
        }
    }
    
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
          super.didUpdateFocus(in: context, with: coordinator)
          coordinator.addCoordinatedAnimations({
              if  context.nextFocusedView  == self.EmailTextField {
                  
                  if self.EmailTextField.isFocused {
                      self.EmailTextField.backgroundColor = focusedBgColor
                      self.EmailTextField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                      
                      DispatchQueue.main.async {
                          self.EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                                         
                                                                                         attributes:  [NSAttributedString.Key.foregroundColor:UIColor.black])
                          
                      }
                  }
              }
           
              
               if context.previouslyFocusedView == self.EmailTextField {
                  self.EmailTextField.backgroundColor = UIColor.black
                  self.EmailTextField.transform = .identity
                  DispatchQueue.main.async {
                      self.EmailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                                     attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
                      
                  }
              }
              
          }, completion: nil)
      }
}
