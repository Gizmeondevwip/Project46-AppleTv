//
//  CategoryListingViewController.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 21/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

class CategoryListingViewController: UIViewController ,categoryListingDelegate{
   
    @IBOutlet weak var NoResultView: UIView!
    
    var channelVideos = [VideoModel]()
    var Categories = [VideoModel]()
    var delegate : categoryListingDelegate!
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var gardientview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowlayout = UICollectionViewFlowLayout()
        self.NoResultView.isHidden = true
        categoriesCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.backgroundColor = .clear
//        flowlayout.itemSize = CGSize(width: view.bounds.width/6 + 10, height: UIScreen.main.bounds.height * 0.2 - 20 )
//
        categoriesCollectionView.collectionViewLayout = flowlayout
           
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        let gradientLayer1:CAGradientLayer = CAGradientLayer()

        gradientLayer.frame.size = self.categoriesCollectionView.frame.size
        gradientLayer.colors =
            [UIColor.black.cgColor,UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)

       

        //Use diffrent colors
//        gardientview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        self.gardientview.layer.addSublayer(gradientLayer)
        categoriesCollectionView.backgroundView = self.gardientview
        NoResultView.backgroundColor = .black
//        NoResultView.addSubview(gardientview)
//        let nib2 =  UINib(nibName: "CategoryTableView", bundle: nil)
//        categoryTableView.register(nib2, forCellReuseIdentifier: "CategoryCell")
//        categoryTableView.delegate = self
//        categoryTableView.dataSource = self
//        getCategoryVideos()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Categories.removeAll()
        categoriesCollectionView.reloadData()

    }
    func getCategoryVideos1(){
        print("delegate called")
    }
    func getCategoryVideos(categoryModel: VideoModel) {
        commonClass.startActivityIndicator(onViewController: self)

        Categories.removeAll()
             var parameterDict: [String: String?] = [ : ]
       
               parameterDict["key"] = String(categoryModel.categoryid!)
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "apple-tv"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
       
             ApiCommonClass.getvideoByCategory(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
               if responseDictionary["error"] != nil {
                 DispatchQueue.main.async {
                    self.NoResultView.isHidden = false
                    commonClass.stopActivityIndicator(onViewController: self)
                 }
               } else {
                 self.Categories = responseDictionary["data"] as! [VideoModel]
                 if self.Categories.count == 0 {
                   DispatchQueue.main.async {
                    self.NoResultView.isHidden = false
                    self.categoriesCollectionView.isHidden = true
                    self.categoriesCollectionView.reloadData()
                    commonClass.stopActivityIndicator(onViewController: self)

                   }
                 } else {
                   DispatchQueue.main.async {
                    print("categoryListApi call")
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.NoResultView.isHidden = true

                    self.categoriesCollectionView.isHidden = false

                     self.categoriesCollectionView.reloadData()
                   }
                 }
               }
             }
           }
    }
extension CategoryListingViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
        if let previousIndexPath = context.previouslyFocusedIndexPath ,
           let cell = categoriesCollectionView.cellForItem(at: previousIndexPath) {
            print("previousIndexPath")
            cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.shadowRadius = 0.0
            cell.contentView.layer.shadowOpacity = 0
        }

        if let indexPath = context.nextFocusedIndexPath,
           let cell = categoriesCollectionView.cellForItem(at: indexPath) {
            print("nextFocusedIndexPath")
            cell.contentView.layer.borderWidth = 6.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.cornerRadius = 8

        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("categories.count",Categories.count)
        return Categories.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width = (self.view.frame.size.width) / 3.3

        return CGSize(width: view.bounds.width/7 + 10, height:  UIScreen.main.bounds.height * 0.3 );
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
        cell.backgroundColor = .clear
        cell.imageView.layer.masksToBounds = true
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.layer.cornerRadius = 8
        if Categories[indexPath.row].show_name != nil{
            cell.videoNameLabel.text = Categories[indexPath.row].show_name
            cell.videoNameLabel.numberOfLines = 2
        }
        else{
            cell.videoNameLabel.text = " "
        }
        if Categories[indexPath.row].logo_thumb != nil{
            cell.imageView.sd_setImage(with: URL(string: showUrl + Categories[indexPath.row].logo_thumb!),placeholderImage:UIImage(named: "placeHolder"))
        }
        else {
            cell.imageView.image = UIImage(named: "placeHolder400*600")
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath as IndexPath) as! PopularCollectionViewCell
//        cell.backgroundColor = .red
//               if Categories[indexPath.row].logo_thumb != nil {
//            cell.videoImageView.sd_setImage(with: URL(string: ((showUrl + Categories[indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
//        }
//        cell.layer.cornerRadius = 8
//        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
        videoDetailView.videoItem = Categories[indexPath.item]
            videoDetailView.fromCategories = false
        self.present(videoDetailView, animated: true, completion: nil)
    }
}
extension CategoryListingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 120, bottom:0, right: 50)
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
}

