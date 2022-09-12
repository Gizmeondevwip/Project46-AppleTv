//
//  SubtitleTextView.swift
//  Justwatchme
//
//  Created by GIZMEON on 23/09/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit



class SubtitlesLabel: UILabel {
    
    var insets: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: text == nil ? rect : rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += insets.left + insets.right
        contentSize.height += insets.top + insets.bottom
        
        return contentSize
    }
}
