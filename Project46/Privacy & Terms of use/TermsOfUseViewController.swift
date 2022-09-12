//
//  TermsOfUseViewController.swift
//  Justwatchme
//
//  Created by GIZMEON on 16/09/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class TermsOfUseViewController: UIViewController,UITextViewDelegate {
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


