//
//  BannerCollectionViewCell.swift
//  Justwatchme
//
//  Created by GIZMEON on 31/08/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//



import UIKit
import TVUIKit
import SDWebImage

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!{
        didSet {
            //   videoImageView.layer.cornerRadius = 25
            // videoImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var metaDataView: UIView!{
        didSet{
//            metaDataView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            
        }
    }
    @IBOutlet weak var moreButton: UIButton!{
        didSet{
            moreButton.isUserInteractionEnabled = true
            
            self.moreButton.layer.cornerRadius = 16
            self.moreButton.clipsToBounds = true
            self.moreButton.layer.borderWidth = 1
              self.moreButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
           self.moreButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
        }
    }
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var metaDataLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
   
    @IBOutlet weak var synopsisLabelWidth: NSLayoutConstraint!{
        didSet{
            synopsisLabelWidth.constant =  UIScreen.main.bounds.width / 3
        }
    }
    
    @IBAction func MoreAction(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // self.layoutIfNeeded()
    }
    internal var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    private var isbtnFirst  = false
    private var isDefault   = false


    internal var titleImage: String! {
        didSet {
            titleImageView.sd_setImage(with: URL(string: titleImage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!),placeholderImage:UIImage(named: "placeHolder"))
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
   
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






//    if context.nextFocusedView is BannerCollectionViewCell && context.previouslyFocusedView  !=  self.moreButton {
//                self.isbtnFirst = true
//        print("morebutton focused")
//        self.setNeedsFocusUpdate()
//    }
//    if context.nextFocusedView  ==  self.moreButton && context.previouslyFocusedView  ==  self.moreButton{
//        self.isDefault = true
//        print("collectionview focused")
//    }
//    if context.nextFocusedView is BannerCollectionViewCell && context.previouslyFocusedView  ==  self.moreButton {
//        self.isbtnFirst = true
//        print("morebutton focused")
//        self.setNeedsFocusUpdate()
//    }
//
//    fileprivate  let scaleFactor: CGFloat = 1.1
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        super.didUpdateFocus(in: context, with: coordinator)
//
//        if context.nextFocusedView == self {
//
//            self.moreButton.setNeedsFocusUpdate()
//            self.moreButton.updateFocusIfNeeded()
//
//            if self.moreButton.isFocused {
//                self.moreButton.backgroundColor = focusedBgColor
//                self.moreButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//
//                self.setNeedsFocusUpdate()
//                self.updateFocusIfNeeded()
//
//
//
//            }
//        } else {
//            UIView.animate(withDuration: 0.2) {
//                self.transform = CGAffineTransform.identity
//                self.titleLabel.isHidden = true
//                self.setNeedsFocusUpdate()
//                self.updateFocusIfNeeded()
//            }
//        }
//    }
