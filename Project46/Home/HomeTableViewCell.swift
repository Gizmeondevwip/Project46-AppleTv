//
//  HomeTableview.swift
//  Justwatchme
//
//  Created by GIZMEON on 26/08/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation


import UIKit

protocol  HomeTableViewCellDelegate:class {
    func didSelectFreeShows(passModel :VideoModel?)
    func didSelectNewArrivals(passModel :VideoModel?)
    func didSelectThemes(passModel :VideoModel?)
    func didSelectDianamicVideos(passModel :VideoModel?)
    func didSelectFilmOfTheDay(passModel :VideoModel?)

    func didSelectPartner(passModel :VideoModel?)
    func didFocusFilmOfTheDay()
    func didFocusNewArrivals(passModel :VideoModel)
    func didFocusThemes(passModel :VideoModel)
    func didFocusDianamicVideos(passModel :VideoModel)
    func didFocusPartner(passModel :VideoModel)

}
class HomeTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet fileprivate var mainCollectionView: UICollectionView!
    @IBOutlet weak var videoTypeLabel: UILabel!
//    let defaultSize = CGSize(width: 370, height: 250)
//    let focusedSize = CGSize(width: 400, height: 250)
    var videoType = ""
    weak var delegate: HomeTableViewCellDelegate!
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
        mainCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)

        videoArray = []
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        mainCollectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)

//        let width = (2 *  bounds.height - cellOffset) / 3
//        let itemSize = CGSize(width: width, height: bounds.height - cellOffset)
//        mainCollectionView.contentSize = CGSize(width: itemSize.width * CGFloat(videoArray!.count), height: bounds.height )
//        (mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
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

        cell.videoImageView.contentMode = .scaleToFill
         if videoType == "NewArrivals" {
            if videoArray![indexPath.row].logo != nil{
                cell.videoImageView.sd_setImage(with: URL(string: showUrl + videoArray![indexPath.row].logo!),placeholderImage:UIImage(named: "placeHolder"))

            }
            else{
                cell.videoImageView.image = UIImage(named: "placeHolder")
            }
            if videoArray![indexPath.row].show_name != nil {

                cell.nameLabel.text = videoArray![indexPath.row].show_name?.uppercased()
            }
            else{
                cell.nameLabel.text = ""
            }
            cell.liveLabel.isHidden = true
            cell.timeLabel.isHidden = true

        } else if videoType == "Now Streaming" {
            if videoArray![indexPath.row].logo != nil {
                cell.videoImageView.sd_setImage(with: URL(string: ((showUrl + videoArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))

            }else {
//                cell.titleText = videoArray![indexPath.row].channel_name
                cell.videoImageView.image = UIImage(named: "placeHolder")
            }
            cell.nameLabel.text = ""
            cell.liveLabel.isHidden = false
            cell.timeLabel.isHidden = true
        }
        else if videoType == "Free Shows"{
            if videoArray![indexPath.row].logo != nil {
                cell.videoImageView.sd_setImage(with: URL(string: ((showUrl + videoArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))

            }else {
                cell.videoImageView.image = UIImage(named: "placeHolder")
            }
            if videoArray![indexPath.row].show_name != nil {

                cell.nameLabel.text = videoArray![indexPath.row].show_name?.uppercased()
            }
            else{
                cell.nameLabel.text = ""
            }
            cell.liveLabel.isHidden = true
            cell.timeLabel.isHidden = true
        }
        else {
            if videoArray![indexPath.row].logo != nil {
                cell.videoImageView.sd_setImage(with: URL(string: ((showUrl + videoArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
            }
            else{
                cell.videoImageView.image = UIImage(named: "placeHolder")

            }
            if videoArray![indexPath.row].show_name != nil {

                cell.nameLabel.text = videoArray![indexPath.row].show_name?.uppercased()
            }
            else{
                cell.nameLabel.text = ""
            }
            cell.liveLabel.isHidden = true
            cell.timeLabel.isHidden = true
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        let prevFocusViewClassName = NSStringFromClass(context.previouslyFocusedView!.classForCoder)
//        let nextFocusedView = NSStringFromClass(context.nextFocusedView!.classForCoder)
//
//        let barButtonName = "UITabBarButton"
//
//        if (context.previouslyFocusedView != nil) && (context.nextFocusedView != nil){
//            if nextFocusedView == barButtonName, let indexPath = context.previouslyFocusedIndexPath,
//               let cell = mainCollectionView.cellForItem(at: indexPath){
//                    // Tabbar disappeared
//                delegate.didFocusFilmOfTheDay()
//                print("tab bar item focused")
//                }
//        }
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

            } else if videoType == "Now Streaming"{
                delegate.didFocusThemes(passModel: videoArray![indexPath.item])

            }
            else if videoType == "Free Shows"{
               delegate.didFocusPartner(passModel: videoArray![indexPath.item])

           }else {
                delegate.didFocusDianamicVideos(passModel: videoArray![indexPath.item])
            }

                delegate.didFocusDianamicVideos(passModel: videoArray![indexPath.item])


        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if videoType == "NewArrivals"{
            delegate.didSelectNewArrivals(passModel: videoArray![indexPath.item])

        } else if videoType == "Now Streaming"{
            delegate.didSelectThemes(passModel: videoArray![indexPath.item])

        }else if videoType == "Free Shows"{
            delegate.didSelectFreeShows(passModel: videoArray![indexPath.item])

        }  else {
            delegate.didSelectDianamicVideos(passModel: videoArray![indexPath.item])
        }
    }

}

extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if videoType == "Film Of The Day" {
            return UIEdgeInsets(top: 0, left: 0, bottom:0, right:0)

        }
        else if videoType == "FilmOfTheDayList"{
            return UIEdgeInsets(top: 20, left: 30, bottom:30, right:20)

        }
        else{
            return UIEdgeInsets(top: 20, left: 30, bottom:30, right:20)

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if videoType == "Film Of The Day" {
            return 0
        }
        else if videoType == "FilmOfTheDayList"{
            return 100

        }
        else{
            return 100

        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if videoType == "Film Of The Day" {
            return 0
        }
        else if videoType == "FilmOfTheDayList"{
            return 20

        }
        else{
            return 20

        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if videoType == "Film Of The Day" {
            return CGSize(width: bounds.width, height: bounds.height)

        }
        else if videoType == "FilmOfTheDayList"{
            let width =  bounds.width / 6
            let height = (3 * width) / 4
            return CGSize(width: width, height: height)
        }
        else{
            let width =  bounds.width / 4.5
            let height = (3 * width) / 4 - 80
            return CGSize(width: width, height: height)
//            let width = (2 *  bounds.height - cellOffset) / 3
//            let itemSize = CGSize(width: width, height: bounds.height - cellOffset)
//            return CGSize(width: width, height: bounds.height)
        }
    }
}

