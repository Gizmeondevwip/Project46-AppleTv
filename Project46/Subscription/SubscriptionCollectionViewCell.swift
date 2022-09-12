//
//  SubscriptionCollectionViewCell.swift
//  Justwatchme
//
//  Created by GIZMEON on 16/06/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//



import Foundation
import UIKit
class SubscriptionCollectionViewCell: UICollectionViewCell {

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
    fileprivate  let scaleFactor: CGFloat = 1.0
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView == self {
            UIView.animate(withDuration: 0.2, animations: {

                self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
                self.layer.borderWidth = 3.0
                self.layer.borderColor = ThemeManager.currentTheme().UIImageColor.cgColor
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
                self.layer.cornerRadius = 24
                self.layer.borderWidth = 2.0
                self.layer.borderColor = UIColor.clear.cgColor
//                self.priceLabel.isHidden = true
            }
        }
    }
}
