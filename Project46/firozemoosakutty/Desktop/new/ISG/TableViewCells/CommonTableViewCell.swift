//
//  CommonTableViewCell.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 11/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit

protocol  CommonVideoTableViewCellDelegate:AnyObject {
    func didSelectFreeShows(passModel :VideoModel?)
    func didSelectNewArrivals(passModel :VideoModel?)
    func didSelectThemes(passModel :VideoModel?)
    func didSelectDianamicVideos(passModel :VideoModel?)
    func didFocusNewArrivals(passModel :VideoModel)
    func didFocusThemes(passModel :VideoModel)
    func didFocusDianamicVideos(passModel :VideoModel)
    func didSelectHomeVideos(passModel :VideoModel?)

}
class CommonTableViewCell: UITableViewCell,UICollectionViewDataSource{
    
    @IBOutlet fileprivate var mainCollectionView: UICollectionView!
    @IBOutlet weak var videoTypeLabel: UILabel!

    var videoType = ""
    weak var delegate: CommonVideoTableViewCellDelegate!
    fileprivate let cellOffset: CGFloat = 100
    var videoArray: [VideoModel]? {
        didSet{
            mainCollectionView.reloadData()
            mainCollectionView.backgroundColor = .clear
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        mainCollectionView.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularCollectionViewCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        videoArray = []
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath as IndexPath) as! PopularCollectionViewCell
        cell.backgroundColor = UIColor.black
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 4
        cell.videoImageView.contentMode = .scaleToFill
        if videoArray![indexPath.row].type == "LIVE" || videoArray![indexPath.row].type == "LINEAR_EVENT" || videoArray![indexPath.row].type == "UPCOMING_EVENT" {
            cell.liveLabel.isHidden = false
        }
        else{
            cell.liveLabel.isHidden = true
        }
        if videoArray![indexPath.row].logo_thumb != nil {
            cell.videoImageView.sd_setImage(with: URL(string: ((videoArray![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
        }
        else{
            cell.videoImageView.image = UIImage(named: "placeHolder")
        }
        if videoArray![indexPath.row].show_name != nil{
            cell.titleText = videoArray![indexPath.row].show_name
            cell.nameLabel.text = videoArray![indexPath.row].show_name
            
        }
        else{
            if videoArray![indexPath.row].type == "LIVE" {
                cell.nameLabel.text = "ISG"
            }
        cell.titleText = ""
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
        if let previousIndexPath = context.previouslyFocusedIndexPath ,
           let cell = mainCollectionView.cellForItem(at: previousIndexPath) {
            print("previousIndexPath")
            cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.shadowRadius = 0.0
            cell.contentView.layer.shadowOpacity = 0
        }

        if let indexPath = context.nextFocusedIndexPath,
           let cell = mainCollectionView.cellForItem(at: indexPath) {
            print("nextFocusedIndexPath")
            cell.contentView.layer.borderWidth = 6.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
//            cell.contentView.layer.shadowColor = UIColor.white.cgColor
//            cell.contentView.layer.shadowRadius = 10.0
//            cell.contentView.layer.shadowOpacity = 0.9
           if videoType == "NewArrivals"{
                
                
                delegate.didFocusNewArrivals(passModel: videoArray![indexPath.item])
                
            } else {
                delegate.didFocusDianamicVideos(passModel: videoArray![indexPath.item])
            }

        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if videoType == "NewArrivals"{
            delegate.didSelectNewArrivals(passModel: videoArray![indexPath.item])
            
        } else if videoType == "Now Streaming"{
            delegate.didSelectThemes(passModel: videoArray![indexPath.item])
            
        }else {
            delegate.didSelectDianamicVideos(passModel: videoArray![indexPath.item])
        }
    }
    
}

extension CommonTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: cellOffset/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellOffset/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellOffset/2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      
            let width  = UIScreen.main.bounds.width / 5
            let height = width * 9 / 16
            return CGSize(width: width, height: height)
           

       
        
    }
}

