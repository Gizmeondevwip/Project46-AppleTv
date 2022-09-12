//
//  customTextfield.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 14/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

let bgColor = UIColor.black
let focusedBgColor = UIColor.lightGray
  
class CustomTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
         
        self.backgroundColor = bgColor
        self.updateFocusIfNeeded()
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
          super.didUpdateFocus(in: context, with: coordinator)
//        coordinator.addCoordinatedAnimations({
//                  if self.isFocused {
//                      self.backgroundColor = focusedBgColor
//                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//                    print(self)
//                    DispatchQueue.main.async {
//                               self.attributedPlaceholder = NSAttributedString(string: "Name",
//
//                                                                                             attributes:  [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
//                             
//                           }
//                  } else {
//                      self.backgroundColor = bgColor
//                      self.transform = .identity
//                    DispatchQueue.main.async {
//                               self.attributedPlaceholder = NSAttributedString(string: "Name",
//
//                                                                                             attributes:  [NSAttributedString.Key.foregroundColor:UIColor.white])
//                             
//                           }
//                  }
//              }, completion: nil)
    }
     
     
}
