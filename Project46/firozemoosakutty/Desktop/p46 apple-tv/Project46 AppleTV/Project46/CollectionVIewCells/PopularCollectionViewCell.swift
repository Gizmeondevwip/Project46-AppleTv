//
//  PopularCollectionViewCell.swift
//  tvOsSampleApp
//
//  Created by Firoze Moosakutty on 25/07/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import TVUIKit
import SDWebImage

class PopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!{
        didSet {
               videoImageView.layer.cornerRadius = 16
             videoImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var moreButton: UIButton!{
        didSet{
            moreButton.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
//            nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var bottomGradientView: UIView!{
        didSet{
            bottomGradientView.setGradientBackground(colorTop:UIColor.clear, colorBottom: UIColor.black, height: 300)
            }
        }
    
    @IBOutlet weak var progressView: UIProgressView!{
        didSet{
            progressView.progressTintColor = .red
            progressView.trackTintColor = .white
            progressView.layer.cornerRadius = 2
                    }
    }
    @IBOutlet weak var liveLabel: UILabel!{
        didSet{
            liveLabel.layer.cornerRadius = 8
            liveLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.layoutIfNeeded()
    }
    internal var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    /// public property to store the text for the title image
    internal var titleImage: String! {
        didSet {
            titleImageView.sd_setImage(with: URL(string: titleImage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!),placeholderImage:UIImage(named: "placeHolder"))
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.moreButton.isFocused
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    fileprivate  let scaleFactor: CGFloat = 1.1
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        super.didUpdateFocus(in: context, with: coordinator)
////
////        if context.nextFocusedView == self {
////            UIView.animate(withDuration: 0.2, animations: {
////
////                self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
////                self.titleLabel.isHidden = false
////            })
////        } else {
////            UIView.animate(withDuration: 0.2) {
////                self.transform = CGAffineTransform.identity
////                self.titleLabel.isHidden = true
////            }
////        }
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
      
    }
    internal func setupUI() {
        titleLabel = UILabel()
        titleImageView = UIImageView()
        titleLabel.isHidden = true
        titleImageView.isHidden = true
    }
    
    fileprivate var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .white
            titleLabel.font = titleLabel.font.withSize(30)
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            
            addSubview(titleLabel)
            titleLabel.isHidden = true
        }
    }
    fileprivate var titleImageView: UIImageView! {
        didSet {
//            titleImageView.adjustsImageWhenAncestorFocused = true
            addSubview(titleImageView)
        }
    }
    
}

