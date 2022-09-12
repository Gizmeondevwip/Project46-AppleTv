//
//  HomeViewController.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 03/09/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import SDWebImage
import ParallaxView
import Reachability

class HomeViewController: UIViewController {
    

    @IBOutlet weak var yearofReleaseName: UILabel!
    @IBOutlet weak var yearOfReleaseTitle: UILabel!
    @IBOutlet weak var videoDetailsLabel: UILabel!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var descriptionWidth: NSLayoutConstraint!
    @IBOutlet weak var producerName: UILabel!
    @IBOutlet weak var resolutionLabel: UILabel!
    @IBOutlet weak var producerTitle: UILabel!
    @IBOutlet weak var cornerImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cornerImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var HomeTableView: UITableView!
    @IBOutlet weak var videoBackgroundImage: UIImageView!{
        didSet{
            videoBackgroundImage.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    let reachability = try! Reachability()
    var maxDianamicArray = [showByCategoryModel]()
    var offsetValue = 0
    var isOffsetChanged = true
    var maxArrayCount = 0
    var freeShows = [VideoModel]()
    var dianamicVideos = [showByCategoryModel]()
    var newArrivedVideos = [VideoModel]()
    var themeVideos = [VideoModel]()
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib2 =  UINib(nibName: "CommonTableViewCell", bundle: nil)
        HomeTableView.register(nib2, forCellReuseIdentifier: "mainTableViewCell")
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        view.backgroundColor = .black
        let width = view.frame.width - (view.frame.width/3)
        self.cornerImageViewWidth.constant = view.frame.width - (view.frame.width/3)
        self.cornerImageViewHeight.constant = (9*width)/16
        self.viewHeight.constant = (9*width)/16
        let bgView = UIView(frame: HomeTableView.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = HomeTableView.frame
        gradientLayer.colors =
            [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.8).cgColor]

        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)

        bgView.layer.insertSublayer(gradientLayer, at: 0)
        HomeTableView.backgroundView = bgView
     

        
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")

            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
        if UserDefaults.standard.string(forKey: "skiplogin_status") != nil{
            let status = UserDefaults.standard.string(forKey: "skiplogin_status")
            print("skiploginstatus",status)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"access_token") == nil {
            self.getToken()
        }
        else{
            self.getDianamicHomeVideos()
        }

        if UserDefaults.standard.string(forKey:"Idfa") != nil {
            print("advertiserid appinstall")
            if !UserDefaults.standard.bool(forKey: "luanchInformationOfApp") {
              UserDefaults.standard.setValue(true, forKey: "luanchInformationOfApp")
              self.app_Install_Launch()
            }
        }
        else{
            print("no advertiserid")
        }

    }
    
    // MARK: Api Calls
    //Call to accces token api
    func getToken() {
        print("getToken from home")
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getToken { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                commonClass.stopActivityIndicator(onViewController: self)
                commonClass.showAlert(viewController:self, messages: "Server error")
            } else {
                
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.getDianamicHomeVideos()

                    
                }
            }
            
        }
    }
    
    // call to single category video api
    func getDianamicHomeVideos() {
        var parameterDict: [String: String?] = [ : ]
          if isOffsetChanged{
              if offsetValue == 0{
                  commonClass.startActivityIndicator(onViewController: self)
                  parameterDict["offset"] = "0"
              }
              else{
                  parameterDict["offset"] = String(offsetValue * 10)
              }
              offsetValue = offsetValue + 1

          }
        print("parameterDict",parameterDict)

        ApiCommonClass.getDianamicHomeVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController:self, messages: "Oops! something went wrong \n please try later")

                }
            } else {
                if let data = responseDictionary["data"] as? [showByCategoryModel]{
                    if data.count > 0 {
                        self.dianamicVideos.append(contentsOf: data)
                        DispatchQueue.main.async {
                            self.HomeTableView.reloadData()
                            commonClass.stopActivityIndicator(onViewController: self)
                            self.HomeTableView.isHidden = false
                            self.didFocusDianamicVideos(passModel: self.dianamicVideos[0].shows![0])
                        }
                    }else{
                        if self.dianamicVideos.count == 0{
                            DispatchQueue.main.async {
                              self.HomeTableView.reloadData()
                              self.maxArrayCount = self.dianamicVideos.count
                              commonClass.stopActivityIndicator(onViewController: self)
                              self.HomeTableView.isHidden = false
                            }
                        }
                        else{
                            self.maxArrayCount = self.dianamicVideos.count
                        }
                    }
            }
                else{
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController:self, messages: "Oops! something went wrong \n please try later")
                    self.HomeTableView.reloadData()


                }
               
            }
        }
    }
    
    

    
    func app_Install_Launch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
      parameterDict["device_type"] = "apple-tv"
      if let longitude = UserDefaults.standard.string(forKey:"longitude") {
        parameterDict["longitude"] = longitude
      }
      if let latitude = UserDefaults.standard.string(forKey: "latitude"){
        parameterDict["latitude"] = latitude
      }
      if let country = UserDefaults.standard.string(forKey:"country"){
        parameterDict["country"] = country
      }
      if let city = UserDefaults.standard.string(forKey:"city"){
        parameterDict["city"] = city
      }
      if let userAgent = UserDefaults.standard.string(forKey:"userAgent"){
           parameterDict["ua"] = userAgent
         }
      if let IPAddress = UserDefaults.standard.string(forKey:"IPAddress") {
        parameterDict["ip_address"] = IPAddress
      }
     
      if let advertiser_id = UserDefaults.standard.string(forKey:"Idfa"){
        parameterDict["advertiser_id"] = advertiser_id
      }
    else{
          parameterDict["advertiser_id"] = "00000000-0000-0000-0000-000000000000"
        }
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
       parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
         parameterDict["width"] =  String(format: "%.3f",UIScreen.main.bounds.width)
         parameterDict["height"] = String(format: "%.3f",UIScreen.main.bounds.height)
         parameterDict["device_make"] = "Apple"
        parameterDict["device_model"] = UserDefaults.standard.string(forKey:"deviceModel")
         if (UserDefaults.standard.string(forKey: "first_name") != nil){
          parameterDict["user_name"] = UserDefaults.standard.string(forKey: "first_name")
         }
      if let user_email = UserDefaults.standard.string(forKey: "user_email"){
       parameterDict["user_email"] = user_email
      }
       
      if let publisherid = UserDefaults.standard.string(forKey: "pubid") {
        parameterDict["publisherid"] = publisherid
      }
      
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
     
      if (UserDefaults.standard.string(forKey:"skiplogin_status") == "false") {
 
      if (UserDefaults.standard.string(forKey: "phone") != nil){
       parameterDict["user_contact_number"] = UserDefaults.standard.string(forKey: "phone")
      }
          
      }
        print("parameter dictionary install ",parameterDict)
        ApiCommonClass.analayticsAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
              
              print("app_Install_Launch")
             
            }
          }
      }
    }
    func firstEventAppLuanch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
      parameterDict["event_type"] = "POP01"
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      if let channelid = UserDefaults.standard.string(forKey:"channelid") {
          parameterDict["channel_id"] = channelid
      }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
      print(parameterDict)
      ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
              print("firstEventAppLuanch")
          }
        }
      }
    }
    
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
                if  pos > 0 && pos > HomeTableView.contentSize.height-50 - scrollView.frame.size.height{
                    print(" you reached end of the table")
                    if maxArrayCount != 0 && (maxArrayCount==dianamicVideos.count){
                        print("max array count")
                    }
                    else{
                        self.getDianamicHomeVideos()
                    }
                }

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  dianamicVideos.count
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! CommonTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
            cell.videoType = "Dianamic"
            let data = dianamicVideos[indexPath.section].shows
            if (data?.count)! >= 10 {
                cell.videoArray = dianamicVideos[indexPath.section].shows
            } else {
                cell.videoArray = dianamicVideos[indexPath.section].shows
            }
        return cell
    }
   
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width  = UIScreen.main.bounds.width / 5
        let height = width * 9 / 16
            if self.dianamicVideos[indexPath.section].shows!.isEmpty {
                return 0
            }
         return height 
    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
            if self.dianamicVideos[section].shows!.isEmpty {
                return 0
            }
       
         return (rowHeight) * 0.2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.frame = CGRect(x: 8, y: 0, width: view.bounds.width, height: (rowHeight) * 0.2).integral
        titleLabel.text =  dianamicVideos[section].category_name
        headerView.addSubview(titleLabel)
        headerView.backgroundColor = .clear
        return headerView
    }
    
    
}
extension HomeViewController: CommonVideoTableViewCellDelegate  {
    func didSelectHomeVideos(passModel: VideoModel?) {
        
    }
    
   
    
   
    func didSelectFreeShows(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
            videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    
    func didSelectNewArrivals(passModel: VideoModel?) {
      
        
    }
    func didSelectThemes(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
              videoDetailView.fromCategories = true
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    func didSelectDianamicVideos(passModel: VideoModel?) {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
            }
    func didSelectHomeVideos(passModel: VideoModel) {

    }
    func didFocusFreeShows(passModel: VideoModel) {
        videoBackgroundImage.sd_setImage(with: URL(string: showUrl + passModel.logo!),placeholderImage:UIImage(named: "placeHolder"))
        if let resolution = passModel.resolution, let producer = passModel.producer, let year = passModel.year {
            var categories = ""
            passModel.category_name?.forEach({ (theme) in
                categories = theme + ",  " + categories
            })
            
            videoDetailsLabel.text = "\(resolution)\n\nProducer: \(producer)\n\nYear: \(year)\n\nThemes: \(categories.dropLast(1))"
        }
    }
    func didFocusNewArrivals(passModel: VideoModel) {
//        producerName.text?.removeAll()
        if passModel.logo != nil{
            videoBackgroundImage.sd_setImage(with: URL(string: ((showUrl + passModel.logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
        }
       
        if let show_name = passModel.show_name {
            
//            \n\n\(resolution)\n\nProducer: \(producer)\n\nYear: \(year)\n\nThemes: \(categories.dropLast(1))"
            videoNameLabel.text = show_name
            
        }
        else{
            videoNameLabel.text?.removeAll()
        }
        if let rating = passModel.rating,let audio = passModel.audio_language_name ,let resolution = passModel.resolution{
            videoDetailsLabel.text =   "\(resolution) • \(audio) • \(rating)  "

        }

        if let description = passModel.synopsis{
            resolutionLabel.text = "\(description)"
//            descriptionWidth.constant = view.frame.width / 3 + 50
            resolutionLabel.numberOfLines = 4
        }
        else{
            resolutionLabel.text?.removeAll()
        }

        videoNameLabel.text = passModel.show_name
    }
    func didFocusThemes(passModel: VideoModel) {
       
         
    }
    func didFocusDianamicVideos(passModel: VideoModel) {
        
        if passModel.logo_thumb != nil{
            videoBackgroundImage.sd_setImage(with: URL(string: ((passModel.logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
            videoBackgroundImage.backgroundColor = .clear
        }
        else{
            videoBackgroundImage.image = UIImage(named: "placeHolder")
        }
        if let show_name = passModel.show_name {
            videoNameLabel.text = show_name
            
        }
        else{
            if passModel.type == "LIVE"{
                videoNameLabel.text = "ISG"
            }
            else{
             videoNameLabel.text?.removeAll()
            }
        }
        if let rating = passModel.rating ,let resolution = passModel.resolution{
            videoDetailsLabel.text =   "\(resolution) • \(rating)  "
        }
        else{
            videoDetailsLabel.text?.removeAll()
        }
        if let description = passModel.synopsis{
            resolutionLabel.text = "\(description)"
//            descriptionWidth.constant = view.frame.width / 3 + 50
            resolutionLabel.numberOfLines = 4
        }
        else{
            resolutionLabel.text?.removeAll()
        }
        
    }
         
}






// MARK: Extensions
extension UIView{
  func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
      let width = UIScreen.main.bounds.width - (UIScreen.main.bounds.width/3)
     let gradientLayer = CAGradientLayer()
     gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
     gradientLayer.locations = [0.0, 1.0]
      gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: 50)
     layer.insertSublayer(gradientLayer, at: 0)
   }
    func setLinearGradientView(colorTop: UIColor, colorBottom: UIColor) {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
           gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//       gradientLayer.locations = [0.0,1.0]
        gradientLayer.frame = UIScreen.main.bounds

       layer.insertSublayer(gradientLayer, at: 0)
     }
    func setGradientBackgroundForDetailScreen(colorTop: UIColor, colorBottom: UIColor) {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
       gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
       layer.insertSublayer(gradientLayer, at: 0)
     }
    
}
