//
//  SearchCollectionCell.swift
//  ISG
//
//  Created by GIZMEON on 15/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class SearchCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override  func awakeFromNib() {
           super.awakeFromNib()
           self.layoutIfNeeded()
       }
       override func layoutSubviews() {
       super.layoutSubviews()
       layoutIfNeeded()
        imageView.backgroundColor = .clear
//        imageView.adjustsImageWhenAncestorFocused = true

       }
    fileprivate  let scaleFactor: CGFloat = 1.15
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
