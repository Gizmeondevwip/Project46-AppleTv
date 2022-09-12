//
//  CommonClass.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 15/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

public class commonClass {
    static let maxLabelWidth = (UIScreen.main.bounds.size.width/2)-20
       static var keyboardHeightValue = CGFloat()
       static var container: UIView = UIView()
       static var loadingView: UIVisualEffectView = UIVisualEffectView()
       static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
       static var animatingDuration = Bool()
       static let window = UIApplication.shared.keyWindow!
       static var userInteractionBoolValue = Bool()
       static var messageBoolValue = Bool()
       static var messageString = String()
       static var messageLabel = UILabel()
    
   static func isValidEmail(email:String) -> Int {
      if  email.isEmpty{
        return 1
      }else{
        print("validate emilId: \(email)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        if result == true{
          return 2
        }else{
          return 3
        }

      }
    }
    static func showAlert(viewController : UIViewController ,messages :String) {
           
           let alert = UIAlertController(title: messages, message: "", preferredStyle: .alert)
           alert.view.tintColor = UIColor().colorFromHexString("207CFF")
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           viewController.present(alert, animated: true, completion: nil)
       }
    
  
    
     let activityIndicator = UIActivityIndicatorView()
         
          static func startActivityIndicator(onViewController: UIViewController) {
     //        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
                 activityIndicator.center =  onViewController.view.center
                 activityIndicator.color = UIColor.gray
                 activityIndicator.style = .whiteLarge
             activityIndicator.tag = 1
             onViewController.view.addSubview(activityIndicator)
             
                 activityIndicator.startAnimating()

           
         }
         
        static func stopActivityIndicator(onViewController: UIViewController) {
             let activityIndicator = onViewController.view.viewWithTag(1) as? UIActivityIndicatorView
             activityIndicator?.stopAnimating()
             activityIndicator?.removeFromSuperview()

            
         }
     
}
