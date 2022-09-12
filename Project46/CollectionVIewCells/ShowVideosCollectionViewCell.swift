//
//  ShowVideosCollectionViewCell.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 23/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit

protocol ShowVideoDelegate:class {
    func didSelectShowVideos(passModel :VideoModel?)
    func didSelectSingleVideos(passModel :VideoModel?)

    func  didSelectCategory(passModel :VideoModel?)
}

class ShowVideosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var PlayImageView: UIImageView!
    @IBOutlet weak var videoThumbnailImageView: UIImageView!

    @IBOutlet weak var videoTitle: UILabel!
    weak var delegate: ShowVideoDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // self.layoutIfNeeded()
    }
    internal var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    var isFromCategories = Bool()
    var videoItem: VideoModel?{
        didSet{
            if isFromCategories {
                if let logo = videoItem?.thumbnail_350_200 {
                 videoThumbnailImageView.sd_setImage(with: URL(string: imageUrl + logo),placeholderImage:UIImage(named: "placeHolder"))
                    videoThumbnailImageView.layer.cornerRadius = 8
                    videoThumbnailImageView.layer.masksToBounds = true
                    videoThumbnailImageView.contentMode = .scaleToFill


                }
                if videoItem?.video_title != nil{
                    videoTitle.numberOfLines = 1
                    videoTitle.text = videoItem?.video_title
                }
            } else {
                if let logo = videoItem?.thumbnail_350_200 {
                    videoThumbnailImageView.sd_setImage(with: URL(string: imageUrl + logo),placeholderImage:UIImage(named: "placeHolder"))
                    videoThumbnailImageView.layer.cornerRadius = 8
                    videoThumbnailImageView.layer.masksToBounds = true
                    videoThumbnailImageView.contentMode = .scaleToFill


                }
                if videoItem?.video_title != nil{
                    videoTitle.numberOfLines = 1

                    videoTitle.text = videoItem?.video_title
                }
            }

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
    fileprivate  let scaleFactor: CGFloat = 1.2
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView == self {
            UIView.animate(withDuration: 0.2, animations: {

                self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
                self.titleLabel.isHidden = false
                if self.isFromCategories {
                    self.delegate.didSelectCategory(passModel: self.videoItem)
                }else {
                      self.delegate.didSelectShowVideos(passModel:self.videoItem)
                }

            })
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
                self.titleLabel.isHidden = true
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        let titleImageViewHeight = bounds.height - bounds.height / 8
        let labelHeight = bounds.height - titleImageViewHeight
        titleLabel.frame = CGRect(x: 8, y: videoThumbnailImageView.center.y - 25, width: bounds.width - 16, height:40).integral
        titleLabel.textAlignment = .center
        self.bringSubviewToFront(titleLabel)
    }
    internal func setupUI() {
        titleLabel = UILabel()
        titleLabel.isHidden = true

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

}
