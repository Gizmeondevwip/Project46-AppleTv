//
//  SubscriptionListCell.swift
//  FestiflixTV
//
//  Created by GIZMEON on 27/04/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class SubscriptionListCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subscriptionNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.layoutIfNeeded()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    fileprivate  let scaleFactor: CGFloat = 1.2
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.nextFocusedView == self {
            UIView.animate(withDuration: 0.2, animations: {
                
                self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
//                self.priceLabel.isHidden = false
//                if self.isFromCategories {
//                    self.delegate.didSelectCategory(passModel: self.videoItem)
//                }else {
//                      self.delegate.didSelectShowVideos(passModel:self.videoItem)
//                }
              
            })
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
//                self.priceLabel.isHidden = true
            }
        }
    }
}
