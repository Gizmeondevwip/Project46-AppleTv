//
//  UITextField.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 14/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import Foundation
import  UIKit

extension UITextField {
    func setBottomBorder() {
//       self.borderStyle = .none
//        self.layer.backgroundColor = UIColor.black.cgColor
//       self.layer.masksToBounds = false
//       self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//       self.layer.shadowOpacity = 1.0
//       self.layer.shadowRadius = 0.0
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
     }
    
   
}

