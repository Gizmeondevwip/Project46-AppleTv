//
//  WatchListViwController.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 18/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
import Reachability
class WatchListViewController: UIViewController{
    @IBOutlet weak var WatchlistCollectionView: UICollectionView!
    var watchList = [VideoModel]()
    fileprivate let cellOffset: CGFloat = 100
    let reachability = try! Reachability()

    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var NoResultView: UIView!
    override func viewDidLoad() {
      super.viewDidLoad()
        view.backgroundColor = .black
        WatchlistCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
       let flowlayout = UICollectionViewFlowLayout()
        WatchlistCollectionView.dataSource = self
        WatchlistCollectionView.delegate = self
//        flowlayout.itemSize = CGSize(width: view.bounds.width/5, height: UIScreen.main.bounds.height * 0.2 )
        self.NoResultView.isHidden = true
        self.NoResultView.backgroundColor = .black
        WatchlistCollectionView.collectionViewLayout = flowlayout
        WatchlistCollectionView.reloadData()
       
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")

            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
    }
   
   

//Exit from app
@objc func menuButtonAction() {
    print("menu pressed")
    let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
   
    self.present(videoDetailView, animated: true, completion: nil)
}
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        
        print("viewWillAppear")
        self.getWatchList()

       
        
//        setupInitialView()


    }
    func setupInitialView() {
       
        
        WatchlistCollectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let width = view.bounds.width / 7
        let itemSize = CGSize(width: width, height: (width * 7) / 4)
//        WatchlistCollectionView.contentSize = CGSize(width: itemSize.width * CGFloat(watchList.count), height:view.bounds.height )
        (WatchlistCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
    }
    func getWatchList() {
        commonClass.startActivityIndicator(onViewController: self)

      ApiCommonClass.getWatchList { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
  //          WarningDisplayViewController().noResultview(view : self.view,title: "Oops!Your List is empty")
            commonClass.stopActivityIndicator(onViewController: self)
            commonClass.showAlert(viewController: self, messages: "Oops! something went wrong \n Please try later")
          }
        } else {
          self.watchList.removeAll()
          self.watchList = responseDictionary["Channels"] as! [VideoModel]
          if self.watchList.count == 0 {
            DispatchQueue.main.async {
                commonClass.stopActivityIndicator(onViewController: self)
              self.WatchlistCollectionView.isHidden = true
                self.NoResultView.isHidden = false
                self.noResultLabel.text = "Oops! your list is empty"

            }
          }
           else {

            DispatchQueue.main.async {
                commonClass.stopActivityIndicator(onViewController: self)
                self.NoResultView.isHidden = true

              self.WatchlistCollectionView.isHidden = false
                       print("wtachlistApi")

              self.WatchlistCollectionView.reloadData()
            }
          }
        }
      }
    }

}
extension WatchListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return watchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
        cell.backgroundColor = .clear
        cell.imageView.layer.masksToBounds = true
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.layer.cornerRadius = 8
        if watchList[indexPath.row].show_name != nil{
            cell.videoNameLabel.text = watchList[indexPath.row].show_name
        }
        else{
            cell.videoNameLabel.text = " "
        }
        if watchList[indexPath.row].logo_thumb != nil{
            cell.imageView.sd_setImage(with: URL(string: showUrl + watchList[indexPath.row].logo_thumb!),placeholderImage:UIImage(named: "placeHolder"))
        }
        else {
            cell.imageView.image = UIImage(named: "placeHolder400*600")
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchListCollection", for: indexPath as IndexPath) as! watchLisCollectionViewCell
//
//        cell.videoImageview.sd_setImage(with: URL(string: showUrl + watchList[indexPath.row].logo_thumb!),placeholderImage:UIImage(named: "placeHolder"))
//        cell.videoImageview.layer.cornerRadius = 8.0
//        cell.videoImageview.layer.masksToBounds = true
//        cell.videoImageview.contentMode = .scaleAspectFill
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
        if let previousIndexPath = context.previouslyFocusedIndexPath ,
           let cell = WatchlistCollectionView.cellForItem(at: previousIndexPath) {
            print("previousIndexPath")
            cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.shadowRadius = 0.0
            cell.contentView.layer.shadowOpacity = 0
        }

        if let indexPath = context.nextFocusedIndexPath,
           let cell = WatchlistCollectionView.cellForItem(at: indexPath) {
            print("nextFocusedIndexPath")
            cell.contentView.layer.borderWidth = 6.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.cornerRadius = 8

        }
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width) / 3.3
//        flowlayout.itemSize = CGSize(width: view.bounds.width/3.3, height: UIScreen.main.bounds.height * 0.3)

        return CGSize(width: view.bounds.width/5, height:  UIScreen.main.bounds.height * 0.2 + 30);
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selctd cell")
        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
        videoDetailView.videoItem = watchList[indexPath.item]
            videoDetailView.fromCategories = false
        self.present(videoDetailView, animated: true, completion: nil)
    }
}
extension WatchListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 30, bottom:30, right: 30)
    }

}
