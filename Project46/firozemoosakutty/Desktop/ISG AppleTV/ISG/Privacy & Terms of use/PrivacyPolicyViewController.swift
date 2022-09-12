//
//  PrivacyPolicyViewController.swift
//  Justwatchme
//
//  Created by GIZMEON on 16/09/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class PrivacyPolicyViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.isUserInteractionEnabled = true;
                textView.isScrollEnabled = true;
                textView.showsVerticalScrollIndicator = true;
                textView.bounces = true;
            textView.isSelectable = true
                textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
       
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
    }
}


class FocusableText: UITextView {

    var data: String?
    var parentView: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

  

     func canBecomeFocused() -> Bool {
        return true
    }

     func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {

        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.layer.backgroundColor = UIColor.clear.cgColor
            }, completion: nil)
        }
    }

}
