//
//  WatchListCollectionViewCell.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 18/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class watchLisCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var videoImageview: UIImageView!
    override  func awakeFromNib() {
           super.awakeFromNib()
           self.layoutIfNeeded()
       }
       override func layoutSubviews() {
       super.layoutSubviews()
       layoutIfNeeded()
//        videoImageview.adjustsImageWhenAncestorFocused = true

       }
//    fileprivate  let scaleFactor: CGFloat = 1.15
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        super.didUpdateFocus(in: context, with: coordinator)
//
//        if context.nextFocusedView == self {
//            UIView.animate(withDuration: 0.2, animations: {
//
//                self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
//            })
//        } else {
//            UIView.animate(withDuration: 0.2) {
//                self.transform = CGAffineTransform.identity
//            }
//        }
//    }
    fileprivate  let scaleFactor: CGFloat = 1.2
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.nextFocusedView == self {
            UIView.animate(withDuration: 0.2, animations: {
                
                self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
               
              
            })
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
            }
        }
    }

}
