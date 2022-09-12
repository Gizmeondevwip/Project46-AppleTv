//
//  VideoDetailsViewController.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 22/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import Reachability
import SwiftyStoreKit
import StoreKit
class VideoDetailsViewController: UIViewController {
    var watchVideo = false
    var watchFlagModel = [LikeWatchListModel]()
    var videoResolution : String!
    var AudioLanguage : String!
    var videoRating : String!
    let reachability = try! Reachability()
    var episodeArray = [VideoModel]()

    @IBOutlet weak var DirectorLabel: UILabel!
    @IBOutlet weak var CastLabel: UILabel!
    @IBOutlet weak var ThemeLabel: UILabel!
    
    
    @IBOutlet weak var SubscriptionListView: UICollectionView!{
        didSet{
            SubscriptionListView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var SubscriptionCVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var videoImageHeight: NSLayoutConstraint!
    @IBOutlet weak var videoImageWidth: NSLayoutConstraint!
    @IBOutlet weak var watchListButton: UIButton!{
        didSet{
            self.watchListButton.layer.cornerRadius = 34
            self.watchListButton.clipsToBounds = true
            self.watchListButton.layer.borderWidth = 1
              self.watchListButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
              self.watchListButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
              self.watchListButton.titleLabel?.textColor = .white
              self.watchListButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        }
      }
    
    @IBOutlet weak var blackGradientHeight: NSLayoutConstraint!
    @IBOutlet weak var metaDataLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoBackgroundImage: UIImageView!
    
    @IBOutlet weak var videoTitleLabel: UILabel!{
        didSet{
            self.videoTitleLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    
    @IBOutlet weak var showvideosCollectionView: UICollectionView!{
        didSet {
            // showvideosCollectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        
    }
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var metaDataView: UIView!
    @IBOutlet weak var metaDataViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seasonTableView: UITableView!
    @IBOutlet weak var seasonTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ratingLabel: UILabel!{
        didSet{
            ratingLabel.layer.borderWidth = 2.0
            ratingLabel.layer.borderColor = UIColor.darkGray.cgColor
            ratingLabel.isHidden = true
        }
    }
    @IBOutlet weak var gradientView: UIView!
    var fromCategories = Bool()
    var ShowData = [ShowDetailsModel]()
    var metadataItem : VideoModel!
    var metadataModel : VideoModel!
    var categoryListArray = [categoriesModel]()

    //var categoryList = [categoriesModel]()
    var languagesList = [languagesModel]()
    var showVideoList = [VideoModel]()
    var categoryList = [VideoModel]()
    fileprivate let cellOffset: CGFloat = 120
    
    var videoItem: VideoModel?
    var myMutableString = NSMutableAttributedString()
    
    
    var skProducts = [SKProduct]()
    // here we set all in app purchase ids
    let productIds: Set<String> = ["com.ios.chicanohollywood_paperview_nine","com.ios.chicanohollywood_Monthly_Subscription"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionViewFrame()
        let nib1 =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        seasonTableView.register(nib1, forCellReuseIdentifier: "HomeTableCell")
        seasonTableView.delegate = self
        seasonTableView.dataSource = self
        seasonTableView.backgroundColor = .clear
        SubscriptionListView.register(UINib(nibName: "SubscriptionListCollectionView", bundle: nil), forCellWithReuseIdentifier: "subscriptionCell")
        self.SubscriptionListView.dataSource = self
        self.SubscriptionListView.delegate = self
        self.SubscriptionListView.reloadData()
       
//        view.backgroundColor = .black
        seasonTableView.contentInsetAdjustmentBehavior = .never
        let width = view.frame.width - view.frame.width/3
       
        self.videoImageWidth.constant = width
        self.videoImageHeight.constant = (9*width)/16

//        let gradient = CAGradientLayer()
//
//        gradient.frame = gradientView.frame
//
//        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//
//        gradient.locations = [0.0, 1.0]
//
//        gradientView.layer.insertSublayer(gradient, at: 0)
//
//        videoBackgroundImage.addSubview(gradientView)

//        videoBackgroundImage.bringSubviewToFront(gradientView)
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")

            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        self.getUserSubscription()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupInitial()

    }
    func getUserSubscription(){
        ApiCommonClass.getUserSubscriptions { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                }
            } else {
                if let videos = responseDictionary["data"] as? [SubscriptionModel] {
                    if videos.count == 0 {
                        Application.shared.userSubscriptionStatus = false
                    }
                    else{
                        Application.shared.userSubscriptionStatus = true
                        
                    }
                    Application.shared.userSubscriptionsArray = videos
                   //  call function to check subscription after intermediate                                                                  login from guest
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        self.videoDescriptionLabel.sizeToFit()
    }
    func setupInitial() {
        if fromCategories {
            getCategoryAccordingtoVideos()
        } else {
            getvideosAccordingToShow()
        }
    }
    func setCollectionViewFrame() {
//        showvideosCollectionView.register(UINib(nibName: "ShowVideosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "showVideosCollectionViewCell")
//

    }
    // API call to get subscription packages
    //@param video_id,uid
    func getVideoSubscriptions(video_id: Int) {
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        parameterDict["vid"] = String(video_id)
        parameterDict["uid"] = UserDefaults.standard.string(forKey:"user_id")
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        ApiCommonClass.getvideoSubscriptions(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                    commonClass.startActivityIndicator(onViewController: self)
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.loadTabbar()
                }
            } else {
                DispatchQueue.main.async {
                    if let videos = responseDictionary["Channels"] as? [VideoSubscriptionModel] {
                        if videos.count == 0 {
                            print("video subscription array",self.VideoSubscriptionArray.count)
                            self.SubscriptionListView.isHidden = true
                            self.SubscriptionListView.reloadData()
                            commonClass.stopActivityIndicator(onViewController: self)
                           print("no result found")
                        } else {
                            self.VideoSubscriptionArray = videos
                            print("video subscription array",self.VideoSubscriptionArray.count)
                            if self.VideoSubscriptionArray[0].ios_keyword != nil{
                                let text = self.getProductDetails(productId: self.VideoSubscriptionArray[0].ios_keyword!)

                            }
                            self.SubscriptionListView.isHidden = false
//                            self.playButton.setTitle(text, for: .normal)
                            self.SubscriptionListView.reloadData()
                            commonClass.stopActivityIndicator(onViewController: self)

//                            cell.packagePrice.text = text
//                            cell.packageDuration.text =
//                            self.GetSelectPremiumContent(SelectedIndexPath : 0)
                        }
                    }
                }
            }
        }
    }
    var VideoSubscriptionArray = [VideoSubscriptionModel]()

    func getvideosAccordingToShow() {
        //Categories.removeAll()
        if let showId = videoItem?.show_id {
            var parameterDict: [String: String?] = [ : ]
            parameterDict["show-id"] = String(showId)
            parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
            commonClass.startActivityIndicator(onViewController: self);            ApiCommonClass.getvideoAccordingToShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        commonClass.showAlert(viewController:self, messages: "Server error")
                        
                        //   WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                        commonClass.stopActivityIndicator(onViewController: self)
                    }
                } else {
                    self.ShowData = responseDictionary["data"] as! [ShowDetailsModel]
                    if self.ShowData.count == 0 {
                        DispatchQueue.main.async {
                            commonClass.stopActivityIndicator(onViewController: self)

                            //                        WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                            //                        CustomProgressView.hideActivityIndicator()
                        }
                    } else {
                        DispatchQueue.main.async {
                            commonClass.stopActivityIndicator(onViewController: self)
                            if let showVideoList = self.ShowData[0].videos,let themes = self.ShowData[0].categories{
                                self.showVideoList =  showVideoList
                                self.categoryListArray = themes

                                if self.ShowData[0].single_video == 1 {
                                    
                                    
                                    let headerHeight = (Int((self.rowHeight) * 0.2) - 50) * 1
                                    self.seasonTableViewHeight.constant = (self.rowHeight * CGFloat(self.showVideoList.count)) + CGFloat(headerHeight)
                                    self.metaDataViewHeight.constant = self.seasonTableViewHeight.constant + self.videoImageHeight.constant
                                    self.mainViewHeight.constant =  self.metaDataViewHeight.constant
                                  
                                    self.didSelectSingleVideos(passModel:self.showVideoList[0])
                                    self.seasonTableView.reloadData()

                                }
                                else{
                                    self.metaDataViewHeight.constant = self.videoImageHeight.constant

                                    let headerHeight = (Int((self.rowHeight) * 0.2) - 50) * showVideoList.count
                                    self.seasonTableViewHeight.constant = (self.rowHeight * CGFloat(self.showVideoList.count)) + CGFloat(headerHeight)
                                    self.metaDataViewHeight.constant = self.seasonTableViewHeight.constant + self.videoImageHeight.constant
                                    self.mainViewHeight.constant =  self.metaDataViewHeight.constant
                                    self.didSelectShowVideos(passModel:self.showVideoList[0])
                                    self.seasonTableView.reloadData()
                                }
                                self.watchFlag()
                                
                                
//                                self.updateUI()
                                // Do any additional setup after loading the view.
//                                SwiftyStoreKit.retrieveProductsInfo(self.productIds) { (result) in
//                                    let products = result.retrievedProducts
//                                    self.skProducts = Array(products)
//                                    if !Application.shared.userSubscriptionStatus {
//                                        if self.showVideoList[0].video_id != nil{
//                                            
//                                            self.getVideoSubscriptions(video_id:self.showVideoList[0].video_id!) // call function to display prices of selected videos
//                                        }
//
//                                    }
//
//
//                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    func getProductDetails(productId : String) -> String {
        var priceText = ""
        for product in skProducts {
            if productId == product.productIdentifier {
                let currencySymbol = product.priceLocale.currencySymbol ?? "$"
                let Price = product.price.doubleValue
                let text = String(format: "\(currencySymbol)%.2f\n", Price)
                priceText = text
                break
            }
        }
        return priceText
    }
    //MARK:- IAP:-Delegate
    // to purchase package
    func purchase(_ purchase: String, atomically: Bool) {
        SwiftyStoreKit.purchaseProduct(purchase, quantity: 1,atomically: false) { (result) in
            switch result {
            case .success(let product):
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                self.didPurchased(product: product, restore: false)
                print("Purchase Success: \(product.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .clientInvalid: print("Not allowed to make the payment")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                  self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                  self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                default: print((error as NSError).localizedDescription)
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                }
            }
        }
    }
    //    @IBAction func restorePurchases() {
    //
    //        NetworkActivityIndicatorManager.networkOperationStarted()
    //        SwiftyStoreKit.restorePurchases(atomically: true) { results in
    //            NetworkActivityIndicatorManager.networkOperationFinished()
    //
    //            for purchase in results.restoredPurchases {
    //                let downloads = purchase.transaction.downloads
    //                if !downloads.isEmpty {
    //                    SwiftyStoreKit.start(downloads)
    //                } else if purchase.needsFinishTransaction {
    //                    // Deliver content from server, then:
    //                    SwiftyStoreKit.finishTransaction(purchase.transaction)
    //                }
    //            }
    //            self.showAlert(self.alertForRestorePurchases(results))
    //        }
    //    }
    //
    
    #if os(iOS)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    #endif
    
    private func didPurchased(product: PurchaseDetails?, restore: Bool) {
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let receiptData):
//                CustomProgressView.hideActivityIndicator()
                let encryptedReceipt = receiptData.base64EncodedString()
                
                self.subscriptionTransaction(status: "success", encryptedReceipt: encryptedReceipt)
                print("Fetch receipt success")
            case .error(let error):
//                CustomProgressView.hideActivityIndicator()
                switch error {
                case ReceiptError.networkError(let error):
                    if (error as NSError).code != 16 {
                        print("rciept error")
//                        WarningDisplayViewController().customActionAlert(viewController :self,title: "Error", message: error.localizedDescription, actionTitles: ["Ok"], actions:[{action1 in
//                            }, nil])
                    }
                default: print("")
//                WarningDisplayViewController().customActionAlert(viewController :self,title: "Error", message: error.localizedDescription, actionTitles: ["Ok"], actions:[{action1 in
//                    }, nil])
                }
            }
        }
    }
    
    @IBAction func playVideoAction(_ sender: Any) {
        self.purchase(self.VideoSubscriptionArray[0].ios_keyword!, atomically: true);        print("plavideo")
    }
    
    
    @IBAction func watchListAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "skiplogin_status") == "true"{
           
            if !watchVideo {
              self.watchVideo = true
              self.watchListShow()
                watchListButton.setTitle("Remove from My List", for: .normal)
            } else {
              self.watchVideo = false
              self.watchListShow()
                watchListButton.setTitle("Add to My List", for: .normal)

            }
            print("skiplogin_status true")

        }
        else{
            print("skiplogin_status false")

            if !watchVideo {
              self.watchVideo = true
              self.watchListShow()
                watchListButton.setTitle("Remove from My List", for: .normal)
            } else {
              self.watchVideo = false
              self.watchListShow()
                watchListButton.setTitle("Add to My List", for: .normal)

            }
        }
       

    }
    func watchListShow() {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["show-id"] = String(ShowData[0].show_id!)
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      if watchVideo {
        parameterDict["watchlistflag"] = "1"
        parameterDict["deletestatus"] = "0"
      } else {
        parameterDict["watchlistflag"] = "0"
        parameterDict["deletestatus"] = "1"
      }

      parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      ApiCommonClass.WatchlistShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            self.watchVideo = !self.watchVideo
          }
        } else {
          DispatchQueue.main.async {
            if self.watchVideo  {
  //            self.watchListButton.set(image:UIImage(named: "checkmark-24") , title: "Watch List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
//              self.watchListButton.tintColor = UIColor.red
                self.watchListButton.setTitle("Remove from My List", for: .normal)

            } else {
                self.watchListButton.setTitle("Add to My List", for: .normal)

            }
          }
        }
      }
    }
    func watchFlag() {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["show-id"] = String(ShowData[0].show_id!)
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      ApiCommonClass.getWatchFlag(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            self.watchVideo = !self.watchVideo
            self.watchListButton.isUserInteractionEnabled = true

          }
        } else {
          DispatchQueue.main.async {
            self.watchListButton.isUserInteractionEnabled = true
            self.watchFlagModel = responseDictionary["data"] as! [LikeWatchListModel]
            if self.watchFlagModel.count != 0 {
              if let watch_flag =  self.watchFlagModel[0].watchlist_flag {
                if watch_flag == 1  {
                  self.watchVideo = true
  //                self.watchListButton.set(image:UIImage(named: "checkmark-24") , title: "Watch List", titlePosition: .bottom, additionalSpacing: -5, state: .normal)
                    self.watchListButton.setTitle("Remove from My List", for: .normal)

                } else {
                  self.watchVideo = false
                    self.watchListButton.setTitle("Add to My List", for: .normal)

                }
              }
            }
          }
        }
      }
    }
    func getCategoryAccordingtoVideos() {
        commonClass.startActivityIndicator(onViewController: self)
        if let genre_id = videoItem?.categoryid {
            var parameterDict: [String: String?] = [ : ]
            parameterDict["genre_id"] = String(genre_id)
            parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
            parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
            parameterDict["device_type"] = "apple-tv"
            parameterDict["pubid"] = UserDefaults.standard.string(forKey:"publisherId")
            ApiCommonClass.getvideoByCategory(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        commonClass.stopActivityIndicator(onViewController: self)
                    }
                } else {
                    self.categoryList = responseDictionary["data"] as! [VideoModel]
                    if self.categoryList.count == 0 {
                        DispatchQueue.main.async {
                            // WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                            //CustomProgressView.hideActivityIndicator()
                            commonClass.stopActivityIndicator(onViewController: self)
                        }
                    } else {
                        DispatchQueue.main.async {
                            // WarningDisplayViewController().noResultView.isHidden = true
                            if !self.categoryList.isEmpty {
                                self.updateUI()
                            }
                            commonClass.stopActivityIndicator(onViewController: self)
                        }
                    }
                }
            }
        }
    }
    
    //API call to update subscription transaction
    func subscriptionTransaction(status: String,encryptedReceipt: String){
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "apple-tv"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["transaction_type"] = "1"
        parameterDict["status"] = status
        parameterDict["mode_of_payment"] = "ios-in-app"
        parameterDict["receiptid"] = encryptedReceipt
        if let subscription_id = VideoSubscriptionArray[0].subscription_id {
            parameterDict["subscription_id"] = String(subscription_id)
        }
        if let price = VideoSubscriptionArray[0].price {
            parameterDict["amount"] = String(price)
        }
        if let ios_keyword = VideoSubscriptionArray[0].ios_keyword {
            parameterDict["product_id"] = ios_keyword
        }
        ApiCommonClass.subscriptionTransaction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    if  status == "success" {
                        print("Your Subscription is processed /n Please wait for some time!")
                        self.subscriptionTransaction(status: status, encryptedReceipt: encryptedReceipt)
                        
                    }
                    
                
                    }
                }
             else {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    if status == "success" {
                        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
                        signupPageView.selectedvideoItem = self.showVideoList[0]
                        if let premiumFlag = self.ShowData[0].premium_flag{
                                signupPageView.premium_flag = premiumFlag
                            }
                        self.present(signupPageView, animated: true, completion: nil)
//                        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
//                        self.present(gotohomeView, animated: true, completion: nil)
//                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
   
    func updateUI() {

//        self.showvideosCollectionView.dataSource = self
//        self.showvideosCollectionView.delegate = self
//        self.showvideosCollectionView.reloadData()
      
        
    }
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == watchListButton {
            self.watchListButton.tintColor = ThemeManager.currentTheme().UIImageColor
            self.watchListButton.backgroundColor =  .gray
        } else {
            self.watchListButton.titleLabel?.textColor = .white
            self.watchListButton.backgroundColor =  ThemeManager.currentTheme().UIImageColor

        }
    }
}

extension VideoDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == showvideosCollectionView{
            if fromCategories {
                return self.categoryList.count
            }
            return showVideoList.count
        }
        else{
            return  self.VideoSubscriptionArray.count
//            if VideoSubscriptionArray.count > 0{
//                return  self.VideoSubscriptionArray.count
//            }
//            else{
//                return 1
//            }
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == showvideosCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showVideosCollectionViewCell", for: indexPath as IndexPath) as! ShowVideosCollectionViewCell
            
            if indexPath.item == 0 {
                cell.delegate = self
            }
            cell.delegate = self
            if fromCategories {
                cell.isFromCategories = true
                cell.videoItem = categoryList[indexPath.row]
                
            } else {
                cell.isFromCategories = false
                cell.videoItem = showVideoList[indexPath.row]
            }
            
            return cell
        }
        else{
            if VideoSubscriptionArray.count > 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriptionCell", for: indexPath as IndexPath) as! SubscriptionListCell
                if VideoSubscriptionArray[indexPath.row].ios_keyword != nil{
                    let text = self.getProductDetails(productId: VideoSubscriptionArray[indexPath.row].ios_keyword!)
                    cell.subscriptionNameLabel.text = self.VideoSubscriptionArray[indexPath.row].subscription_name
                    cell.priceLabel.text = text
                }
               
                cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
            
                self.watchListButton.clipsToBounds = true
                self.watchListButton.layer.borderWidth = 1
                  cell.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
               
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriptionCell", for: indexPath as IndexPath) as! SubscriptionListCell
                cell.backgroundColor = ThemeManager.currentTheme().grayImageColor
            
                
                return cell
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    
        if collectionView == showvideosCollectionView{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = showvideosCollectionView.cellForItem(at: previousIndexPath) {
                print("previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = showvideosCollectionView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 6.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.cornerRadius = 8

            }
        }
        else{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = SubscriptionListView.cellForItem(at: previousIndexPath) {
                print("previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = SubscriptionListView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 6.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.cornerRadius = 8

            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == showvideosCollectionView{
            let width = (self.view.frame.size.width) / 3.3


            return CGSize(width: view.bounds.width/5, height:  UIScreen.main.bounds.height * 0.2 + 40);
        }
        else{
            if VideoSubscriptionArray.count > 0{
                print("video subscription array",VideoSubscriptionArray.count)
                self.SubscriptionCVHeight.constant = 120
                return CGSize(width:  view.bounds.width/8, height: self.SubscriptionCVHeight.constant - 20 );

            }
            else{
                self.SubscriptionCVHeight.constant = 0
                return CGSize(width:  view.bounds.width/8, height: self.SubscriptionCVHeight.constant );
            }


        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == showvideosCollectionView{
        return UIEdgeInsets(top: 20, left: 8, bottom:30, right: 20)
        }
        else{
            return UIEdgeInsets(top: 10, left: 30, bottom:10, right: 30)
        }

//        return UIEdgeInsets(top: cellOffset / 2, left: 0, bottom: cellOffset / 2, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == showvideosCollectionView{
        if UserDefaults.standard.string(forKey: "skiplogin_status") == "true"{
           
            print("skiplogin_status true")
            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
            signupPageView.selectedvideoItem = showVideoList[indexPath.row]
            if let premiumFlag = ShowData[0].premium_flag{
                signupPageView.premium_flag = premiumFlag
            }
            self.present(signupPageView, animated: true, completion: nil)
            commonClass.stopActivityIndicator(onViewController: self)

        }
        else{
            print("'nvMSXNHchmncdhmncbhndcba'")
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
        signupPageView.selectedvideoItem = showVideoList[indexPath.row]
            if let premiumFlag = ShowData[0].premium_flag{
                signupPageView.premium_flag = premiumFlag
            }
        self.present(signupPageView, animated: true, completion: nil)
        commonClass.stopActivityIndicator(onViewController: self)
        }
        }
        else{
            if self.VideoSubscriptionArray[indexPath.row].ios_keyword! != "" {
                self.purchase(self.VideoSubscriptionArray[indexPath.row].ios_keyword!, atomically: true)
            }
        }
    }
}
extension VideoDetailsViewController: ShowVideoDelegate  {
    func didSelectSingleVideos(passModel: VideoModel?) {
        if let image = passModel?.thumbnail_350_200 {
            self.videoBackgroundImage.sd_setImage(with: URL(string: imageUrl + image),placeholderImage:UIImage(named: "lightGrey"))
            self.videoBackgroundImage.contentMode = .scaleToFill
        }
        if let title = passModel?.video_title{
            self.videoTitleLabel.text = title.uppercased()
        }
        
        if let resolution =  ShowData[0].resolution {
            self.metaDataLabel.text = resolution
        }
        if  let videoRating = ShowData[0].rating {
            self.ratingLabel.text = videoRating
            self.ratingLabel.isHidden = false

        }
        else{
            self.ratingLabel.isHidden = true
        }
        if let audio_language_name = ShowData[0].audio_language_name{
            DirectorLabel.text = "Audio : \(audio_language_name)"
            myMutableString = NSMutableAttributedString(string: DirectorLabel.text! as String)
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().UIImageColor, range: NSRange(location:0,length:8))
            self.DirectorLabel.attributedText = myMutableString
        }
        if let description = passModel?.video_description{
          self.videoDescriptionLabel.numberOfLines = 4
            self.videoDescriptionLabel.text = description
        }
        if let cast = passModel?.show_cast{
            CastLabel.text = "CAST : \(cast)"
            myMutableString = NSMutableAttributedString(string: CastLabel.text! as String)
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().UIImageColor, range: NSRange(location:0,length:4))
            self.CastLabel.attributedText = myMutableString
        }
        if !categoryListArray.isEmpty {
            var name = ""
            for i in categoryListArray {
                name =  name + "," + (i.category_name!)
            }
            print(String(name.dropFirst()))
            ThemeLabel.text = "THEME : \(name.dropFirst())"
            myMutableString = NSMutableAttributedString(string: ThemeLabel.text! as String)
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().UIImageColor, range: NSRange(location:0,length:5))
            self.ThemeLabel.attributedText = myMutableString
        }
//        self.playButton.isEnabled = true
        self.watchListButton.isEnabled = true

    }
    func didSelectShowVideos(passModel: VideoModel?) {
        if let image = passModel?.videos![0].thumbnail_350_200 {
            self.videoBackgroundImage.sd_setImage(with: URL(string: imageUrl + image),placeholderImage:UIImage(named: "lightGrey"))
            self.videoBackgroundImage.contentMode = .scaleToFill
        }
        if let title = passModel?.videos![0].video_title{
            self.videoTitleLabel.text = title.uppercased()
        }
        
        if let resolution =  ShowData[0].resolution {
            self.metaDataLabel.text = resolution
        }
        if  let videoRating = ShowData[0].rating {
            self.ratingLabel.text = videoRating
            self.ratingLabel.isHidden = false

        }
        else{
            self.ratingLabel.isHidden = true

        }
        if let audio_language_name = ShowData[0].audio_language_name{
            DirectorLabel.text = "AUDIO : \(audio_language_name)"
            myMutableString = NSMutableAttributedString(string: DirectorLabel.text! as String)
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().UIImageColor, range: NSRange(location:0,length:8))
            self.DirectorLabel.attributedText = myMutableString
        }
        if let description = passModel?.videos![0].video_description{
          self.videoDescriptionLabel.numberOfLines = 4
            self.videoDescriptionLabel.text = description
        }
        if let cast = passModel?.videos![0].show_cast{
            CastLabel.text = "CAST : \(cast)"
            myMutableString = NSMutableAttributedString(string: CastLabel.text! as String)
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().UIImageColor, range: NSRange(location:0,length:4))
            self.CastLabel.attributedText = myMutableString
        }
        if !categoryListArray.isEmpty {
            var name = ""
            for i in categoryListArray {
                name =  name + "," + (i.category_name!)
            }
            print(String(name.dropFirst()))
            ThemeLabel.text = "THEME : \(name.dropFirst())"
            myMutableString = NSMutableAttributedString(string: ThemeLabel.text! as String)
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().UIImageColor, range: NSRange(location:0,length:5))
            self.ThemeLabel.attributedText = myMutableString
        }
//        self.playButton.isEnabled = true
        self.watchListButton.isEnabled = true
//        self.playButton.isEnabled = true
        self.watchListButton.isEnabled = true

    }
    func printSecondsToHoursMinutesSeconds (seconds:Int) -> () {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
      print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func didSelectCategory(passModel: VideoModel?) {
        print("didSelectCategory",URL(string: showUrl + (passModel?.logo_thumb)!))

        if let logo = passModel?.logo_thumb {
            self.videoBackgroundImage.sd_setImage(with: URL(string: showUrl + logo),placeholderImage:UIImage(named: "lightGrey"))
            
        }
        
        if let cast = passModel?.show_cast{
            CastLabel.text = "cast : \(cast)"
        }
        self.playButton.isEnabled = true
        self.watchListButton.isEnabled = true
        self.metaDataLabel.text = passModel?.resolution
        self.videoBackgroundImage.contentMode = .scaleToFill
        self.videoTitleLabel.text = passModel?.show_name
        self.videoDescriptionLabel.text = passModel?.synopsis
        self.videoDescriptionLabel.numberOfLines = 0

        
    }
}
extension VideoDetailsViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
   
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  showVideoList.count
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        cell.videoType = "VideoDetails"
        if ShowData[0].single_video == 1 {
            cell.videoArray =  self.showVideoList
        }
        else{
            cell.videoArray =  self.showVideoList[indexPath.section].videos

        }
        return cell
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ShowData[0].single_video == 1 {
            return rowHeight
        }
        else{
            if self.showVideoList[indexPath.section].videos!.isEmpty {
                return 0
            }
            return rowHeight
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if ShowData[0].single_video == 1 {
            return (rowHeight) * 0.2 - 50
        }
        else{
            if self.showVideoList[section].videos!.isEmpty {
                return 0
            }
            return (rowHeight) * 0.2 - 50
        }
           

       
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.frame = CGRect(x: 30, y: 0, width: view.bounds.width, height: (rowHeight) * 0.2 - 20).integral
        if ShowData[0].single_video == 1 {
        titleLabel.text =  ""

        }
        else{
            titleLabel.text =  " Season \(self.showVideoList[section].season!)"

        }
        headerView.addSubview(titleLabel)
        headerView.backgroundColor = .clear
        return headerView
    }
    
    
}
extension VideoDetailsViewController: HomeTableViewCellDelegate  {
    func didSelectHomeVideos(passModel: VideoModel) {
        
    }
    
   
    func didSelectDianamicVideos(passModel: VideoModel?) {
        let videoPlayerController =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
        videoPlayerController.selectedvideoItem = passModel
        if let premiumFlag = self.ShowData[0].premium_flag{
            videoPlayerController.premium_flag = premiumFlag
            }
        if passModel?.watched_duration != nil && passModel?.watched_duration != 0{
            print("watched duration true")
            videoPlayerController.fromContinueWatching = true
            videoPlayerController.watchedDuration = (passModel?.watched_duration)!
        }
        else{
            print("watched duration false")
            videoPlayerController.fromContinueWatching = false
            videoPlayerController.watchedDuration = 0
        }
        self.present(videoPlayerController, animated: true, completion: nil)
        print("selection on  episodes",passModel?.video_id)

    }
      func didFocusDianamicVideos(passModel: VideoModel) {
          if let image = passModel.thumbnail_350_200 {
              self.videoBackgroundImage.sd_setImage(with: URL(string: imageUrl + image),placeholderImage:UIImage(named: "lightGrey"))
              self.videoBackgroundImage.contentMode = .scaleToFill
          }
          if let title = passModel.video_title{
              self.videoTitleLabel.text = title.uppercased()
          }
          
        
          if let description = passModel.video_description{
            self.videoDescriptionLabel.numberOfLines = 4
              self.videoDescriptionLabel.text = description
          }
          if !categoryListArray.isEmpty {
              var name = ""
              for i in categoryListArray {
                  name =  name + "," + (i.category_name!)
              }
              print(String(name.dropFirst()))
              ThemeLabel.text = "THEME : \(name.dropFirst())"
              myMutableString = NSMutableAttributedString(string: ThemeLabel.text! as String)
              myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeManager.currentTheme().UIImageColor, range: NSRange(location:0,length:5))
              self.ThemeLabel.attributedText = myMutableString
          }
  //        self.playButton.isEnabled = true
          self.watchListButton.isEnabled = true
          print("Focus on  episodes",passModel.video_id)
    }
    
}






extension CALayer {
   func addGradienBorder(colors:[UIColor],width:CGFloat = 1) {
       let gradientLayer = CAGradientLayer()
       gradientLayer.frame =  CGRect(origin: .zero, size: self.bounds.size)
       gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
       gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
       gradientLayer.colors = colors.map({$0.cgColor})

       let shapeLayer = CAShapeLayer()
       shapeLayer.lineWidth = width
       shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
       shapeLayer.fillColor = nil
       shapeLayer.strokeColor = UIColor.black.cgColor
       gradientLayer.mask = shapeLayer

       self.addSublayer(gradientLayer)
   }

}
