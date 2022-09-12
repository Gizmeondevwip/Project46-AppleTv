//
//  NewsViewController.swift
//  RunwayTV
//
//  Created by GIZMEON on 08/06/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class NewsViewController:UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.textColor = ThemeManager.currentTheme().UIImageColor
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.textColor = .white
            descriptionLabel.numberOfLines = 5
        }
    }
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            self.playButton.layer.cornerRadius = 34
            self.playButton.clipsToBounds = true
            self.playButton.layer.borderWidth = 1
              self.playButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
            self.playButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
              self.playButton.titleLabel?.textColor = .white
              self.playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            self.playButton.setTitle("PLAY", for: .normal)
        }
    }
    @IBOutlet weak var tagCollectionView: UICollectionView!{
        didSet{
            tagCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        }
    }
    @IBOutlet weak var tagCollectionVieHeight: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!{
    didSet{
        imageCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
}
    @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
    var video: VideoModel!
    var newsModel = [VideoModel]()
    var multipleNewsImageArray = [String?]()
    var tagArray = [String?]()
    var newsId : Int?
    var eventId : Int?
    var isFromUpcomingEvents = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newCollectionCell")
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.tagCollectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newCollectionCell")
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        let width =  UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 2)
        self.imageViewWidth.constant = width
        self.imageViewHeight.constant = (width*9)/16
        if isFromUpcomingEvents{
//            getLinearEventDetails(id: eventId)
//            self.playButton.isHidden = true
        }
        else{
            getNewsDetails(newsId:newsId)

        }
        
    }
    @IBAction func playAction(_ sender: Any) {
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
        signupPageView.selectedvideoItem = video
       
        self.present(signupPageView, animated: true, completion: nil)
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == playButton {
            self.playButton.titleLabel?.textColor = .white
            self.playButton.backgroundColor =  .gray
            self.playButton.titleLabel?.text = "PLAY"
        } else {
            self.playButton.titleLabel?.textColor = .white
            self.playButton.backgroundColor =  ThemeManager.currentTheme().UIImageColor
            self.playButton.titleLabel?.text = "PLAY"
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    
        if collectionView == tagCollectionView{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = tagCollectionView.cellForItem(at: previousIndexPath) {
                print("previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = tagCollectionView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 6.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.cornerRadius = 8

            }
        }
        if collectionView == imageCollectionView{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = imageCollectionView.cellForItem(at: previousIndexPath) {
                print("previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = imageCollectionView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 6.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.cornerRadius = 8

            }
        }
    }
    func getNewsDetails(newsId:Int?) {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["news-id"] = String(newsId!)
        print("parameterDict",parameterDict)
        ApiCommonClass.GetNewsDetails(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController:self, messages: "Oops! something went wrong \n please try later")

                }
            } else {
                if let data = responseDictionary["data"] as? [VideoModel] {
                    if data.count == 0{
                        commonClass.showAlert(viewController:self, messages: "No News Found!!")
                        commonClass.stopActivityIndicator(onViewController: self)
                    }else{
                        self.newsModel = data
                        DispatchQueue.main.async{
                            if let multipleImages = self.newsModel[0].images{
                                self.multipleNewsImageArray = multipleImages
                                if multipleImages.count > 0{
                                    self.imageCollectionView.reloadData()
                                }
                            }
                            if let tags = self.newsModel[0].video_tags{
                                self.tagArray = tags
                                if tags.count > 0{
                                    self.tagCollectionView.reloadData()
                                }
                            }
                            if self.newsModel[0].videos!.count > 0{
                                self.playButton.isHidden = false
                                self.playButton.isUserInteractionEnabled = true
                                if let videoModel = self.newsModel[0].videos?[0]{
                                    self.video = videoModel
                                }
                            }
                            else{
                                self.playButton.isHidden = true
                            }
                            if let newsDescription  = self.newsModel[0].synopsis{
                                self.descriptionLabel.text = newsDescription
                            }
                            self.titleLabel.text = self.newsModel[0].show_name
                            if let newsImage =  self.newsModel[0].logo_thumb{
                                
                                self.imageView.sd_setImage(with: URL(string: (( newsImage).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                            }
                            else {
                                self.imageView.image = UIImage(named: "landscape_placeholder")
                            }

                        }
                    }
                }
               
               
            }
        }
    }
    
    

}
extension NewsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView{
           return tagArray.count
        }
        else{
            return multipleNewsImageArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCollectionCell", for: indexPath as IndexPath) as! NewsCollectionViewCell
        
        if collectionView == tagCollectionView{
            cell.titleLabel.text = tagArray[indexPath.item]
            cell.imageView.isHidden = true
            cell.backgroundColor = ThemeManager.currentTheme().UIImageColor
            cell.layer.cornerRadius = 16
        }
        else{
              
            cell.imageView.sd_setImage(with: URL(string: (( multipleNewsImageArray[indexPath.row])!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            cell.layer.cornerRadius = 16
            cell.titleLabel.isHidden = true

            }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView{
            return CGSize(width: 200, height: 80)

        }
        else{
            let width = UIScreen.main.bounds.width / 5
            let height = (width * 9) / 16
            self.imageCollectionViewHeight.constant = height
            return CGSize(width: width, height: height)

        }
    }
    
}
