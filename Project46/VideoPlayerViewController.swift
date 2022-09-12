//
//  VideoPlayerViewController.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 24/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import GoogleInteractiveMediaAds
import Reachability


class VideoPlayerViewController: AVPlayerViewController,IMAAdsLoaderDelegate ,IMAAdsManagerDelegate{
  
  
    var selectedvideoItem: VideoModel?
    var token = ""
    var videos = [VideoModel]()
      var categoryModel : VideoModel!

    var avPlayer: AVPlayer? = AVPlayer()
    var contentPlayerLayer: AVPlayerLayer?
    var observer: Any!
    var video: VideoModel!
//    var contentPlayhead: IMAAVPlayerContentPlayhead?
//    var adsLoader: IMAAdsLoader!
//    var adsManager: IMAAdsManager!
//    var companionSlot: IMACompanionAdSlot?
    var isAdPlayback = false
    var isLandscape = false
    let playerItem: AVPlayerItem? = nil
    var videoHeight = CGFloat()
    var videoPlayerHeight = CGFloat()
    var adPositionsArray = Array<Float>()
    var isPlaying = true
    var videoName = ""
    var videoTitle = ""
    var addLink = ""
    var videoId = Int()
    var channelId = ""
    var channelName = ""
    var liked = ""
    var theme = ""
    var programeTitle = ""
    var appStoreEncodedUrl = ""
    var videoStartTime = ""
    var categoryList = ""
    var videoDuration = Double()
    var watchUpdateFlag = false
//    var reachability = Reachability()!
    var sampleArray = Array<Float>()
    var videoDescription = ""
      var isFromSub = false

    var fullScreenValue = Int()
    var videoPlayerWidth = Int()
    var videoPlayerMacroHeight = Int()
    var btnLeftMenu : UIButton = UIButton()
    var hidevideoController = true
    var normalScreenButtonflag = false
//    var adDisplayContainer:IMAAdDisplayContainer?
    var fromNotification = Bool()
    var dropDownflag = true
    var videoNotificationId = Int()
    var interstitial_status = Int()
    var mobpub_interstitial_status = Int()
    private var imageView: UIImageView!
    var isPresentController = false
    var subscribedUser = false
    var premium_flag = Int()
    var isfromSubscription = false
    var isbackActionPerformed = false
   
    var pointsArr = Array<String>()
    var LabelDict: [String: NSRange?] = [ : ]
    var replacedString = ""
    var countTimer:Timer!
    var counter = 15
    var videoPlayingeventValue = false
    var parsedPayload: NSDictionary?
    var rotationAngle : CGFloat!
      var showId = Int()

    @IBOutlet weak var videoView: UIView!
//    let overlayView = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        commonClass.stopActivityIndicator(onViewController: self)

        self.collectionViewSelectedVideo(selectedVideoModel: self.selectedvideoItem!)
        
        

        
    }
    
    
    
    func collectionViewSelectedVideo(selectedVideoModel : VideoModel) {
      self.video = selectedVideoModel
      if video.premium_flag == 1 || video.payper_flag == 1 || video.rental_flag == 1{
//        self.getVideoSubscriptions(video_id: video.video_id!)
       
      }
      else{
        self.initialView()
      }
    }
    func initialView(){
      if fromNotification == true {
        getSelectedVideo(indexpath: videoNotificationId)
      } else {
        getSelectedVideo(indexpath: video.video_id!)
      }
 
      
    }
    func getSelectedVideo(indexpath: Int) {
      videos.removeAll()
      self.dropDownflag = true
      var parameterDict: [String: String?] = [ : ]
      parameterDict["vid"] = String(indexpath)
      parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      ApiCommonClass.GetSelectedVideo(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
//            self.videoView.isHidden = true
            
          }
        } else {
          self.videos.removeAll()
          self.videos = responseDictionary["data"] as! [VideoModel]
          if self.videos.count == 0 {
            DispatchQueue.main.async {
//                self.videoView.isHidden = true

            }
          } else {
            DispatchQueue.main.async {
              self.video = self.videos[0]
              Application.shared.selectedVideoModel = self.video
              if (self.video.premium_flag == 0 || self.video.payper_flag == 0 || self.video.rental_flag == 0) {
                self.didSelectNonPremiumVideo()
               
              } else {
                self.playVideoAfterSubscription()
              }
            }
          }
        }
      }
    }
    func didSelectNonPremiumVideo() {
        print("didSelectNonPremiumVideo")
        ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
          DispatchQueue.main.async {
            if let val = responseDictionary["error"] {
            } else {
              self.token = responseDictionary["Channels"] as! String
              self.setUpInitial()
//              self.replaceMacros()
              self.setUpContentPlayer()
//              self.setUpAdsLoader()
//              self.requestAds()
            }
          }
        }
    }

    @objc func  playVideoAfterSubscription(){
        print("playVideoAfterSubscription")

        self.setUpInitial()
        self.setUpContentPlayer()
//        self.setUpAdsLoader()
//        self.requestAds()
    }
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    func showContentPlayer() {
      self.addChild(playerViewController)
      playerViewController.view.frame = self.view.bounds
      self.view.insertSubview(playerViewController.view, at: 0)
      playerViewController.didMove(toParent:self)
        playerViewController.player?.play()
    }

    func hideContentPlayer() {
      // The whole controller needs to be detached so that it doesn't capture  events from the remote.
      playerViewController.willMove(toParent:nil)
      playerViewController.view.removeFromSuperview()
      playerViewController.removeFromParent()
    }
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        print("IMAAdsLoadedData")

        adsManager = adsLoadedData.adsManager

        adsManager.delegate = self
      adsManager.initialize(with: nil)
    }

    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
      print("Error loading ads: " + adErrorData.adError.message)
      showContentPlayer()
      playerViewController.player?.play()
    }
    // MARK: - IMAAdsManagerDelegate

      func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print("didReceive event")

        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
          adsManager.start()
        }
      }
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Fall back to playing content
        print("AdsManager error: " + error.message)
        showContentPlayer()
        playerViewController.player?.play()
      }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
      // Pause the content for the SDK to play ads.
      playerViewController.player?.pause()
      hideContentPlayer()
        print("adsManagerDidRequestContentPause")

    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        print("adsManagerDidRequestContentResume")

      // Resume the content since the SDK is done playing ads (at least for now).
      showContentPlayer()
      playerViewController.player?.play()
    }
    static let AdTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="
    deinit {
       NotificationCenter.default.removeObserver(self)
     }
    func setUpInitial() {
    

      if self.video.video_name != nil {
        videoName = video.video_name!

      }
      
      if self.video.ad_link != nil {
          addLink = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="
      }
      if self.video.video_title != nil {
        

      }
      if self.video.video_duration != nil {
        videoDuration = Double(video.video_duration!)
      }
      if self.video.channel_id != nil {
        channelId = String(self.video.channel_id!)
      }
      if self.video.channel_name != nil {
        channelName = self.video.channel_name!
      }
      if self.video.video_id != nil {
        videoId = video.video_id!
      }
      if self.video.channel_name != nil {
        videoTitle = self.video.channel_name!
      }
      if  self.video.thumbnail != nil {

       
      }
  //    if let subtitle = self.video.subtitle {
  //      self.subtitleUrl = subtitle
  //    }
      if let category_name = self.video.category_name{
        if !category_name.isEmpty {
          var name = ""
          for categoryListArray in category_name {
            print(categoryListArray)
            name =  name + "," + (categoryListArray)
          }
          print(String(name.dropFirst()))
          self.categoryList = String(name.dropFirst())
        }
      }
      if addLink == "" {
      
      } else {
      }
//      if reachability.connection != .none {
        if self.video.video_name != nil {
          self.GenerateToken(flag: false)
        }
      
    }
    var playerViewController: AVPlayerViewController!
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    
    func setUpAdsLoader() {
       adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
//        adsManager.delegate = self
//        adsManager.initialize(with: nil)


     }
    func requestAds() {
      // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
      // Create an ad request with your ad tag, display container, and optional user context.
      let request = IMAAdsRequest(
          adTagUrl: VideoPlayerViewController.AdTagURLString,
          adDisplayContainer: adDisplayContainer,
          contentPlayhead: contentPlayhead,
          userContext: nil)

      adsLoader.requestAds(with: request)
    }
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader.contentComplete()
      }
    func setUpContentPlayer() {
  //    if let subtitleUrl = self.subtitleUrl {
  //      self.parseSubTitle(Url : subtitleUrl)
  //    }
        
       let contentUrl = URL(string: String(format:videoName))
      let headers = ["token": token]
      let asset: AVURLAsset = AVURLAsset(url: contentUrl!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
      let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
      avPlayer = AVPlayer(playerItem: playerItem)
     
        playerViewController = AVPlayerViewController()
        playerViewController.player = avPlayer
          contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
              NotificationCenter.default.addObserver(
                self,
                selector: #selector(VideoPlayerViewController.contentDidFinishPlaying(_:)),
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: avPlayer?.currentItem);
        showContentPlayer()
//      if addLink == "" {
//        self.avPlayer?.play()
//      } else {
//        self.avPlayer?.play()
//      }
      // Size, position, and display the AVPlayer.
//      contentPlayerLayer!.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width , height:  self.view.frame.size.height )
//        self.view.layer.addSublayer(contentPlayerLayer!)
//      contentPlayerLayer?.videoGravity=AVLayerVideoGravity.resizeAspect
      // Create content playhead
//      contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
//      NotificationCenter.default.addObserver(forName:NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer!.currentItem, queue:nil){ [weak avPlayer] notification in
        // Make sure we don't call contentComplete as a result of an ad completing.
//        if (notification.object as! AVPlayerItem) == avPlayer?.currentItem {
//          if self.adsLoader != nil {
//            self.adsLoader.contentComplete()
//          }
//        }

//      }
     

      
      

    }
//    var adsLoader: IMAAdsLoader!
//    var adsManager: IMAAdsManager!
//    var adDisplayContainer:IMAAdDisplayContainer?
//    var contentPlayhead: IMAAVPlayerContentPlayhead?
//
//    func setUpAdsLoader() {
//      adsLoader = IMAAdsLoader(settings: nil)
//      adsLoader.delegate = self
//    }

//    func requestAds() {
//      // Create ad display container for ad rendering.
//        adDisplayContainer = IMAAdDisplayContainer(adContainer: videoView, viewController: self, companionSlots: nil)
//      // Create an ad request with our ad tag, display container, and optional user context.
//      let request = IMAAdsRequest(
//        adTagUrl: addLink,
//        adDisplayContainer: adDisplayContainer,
//        contentPlayhead: contentPlayhead,
//        userContext: nil)
//      adsLoader.requestAds(with: request)
//    }
    func GenerateToken(flag : Bool)  {
        ApiCommonClass.generateVideoToken { (responseDictionary: Dictionary) in
            DispatchQueue.main.async {
                if let val = responseDictionary["error"] {
                    //WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
                } else {
                   self.token = responseDictionary["data"] as! String
                    // self.metadata.setString(self.token, forKey: )
                    //  metadata.setString(self.video.video_title!, forKey: kGCKMetadataKeyTitle)
                    if ((self.interstitial_status == 0) || (flag == true )) {
//                        self.setUpContentPlayer()
//                        self.setUpAdsLoader()
//                        self.requestAds()
                    }
                }

            }
        }
    }
    func replaceMacros() {
      let bundleID = Bundle.main.bundleIdentifier
      if bundleID != nil {
        let originalBundleIdString = bundleID
        let encodedBundleIdUrl = originalBundleIdString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        addLink = addLink.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
      } else {
        let originalBundleIdString = "com.happitv.ios"
        let encodedBundleIdUrl = originalBundleIdString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        addLink = addLink.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
      }
      videoPlayerWidth = 640
      addLink = addLink.replacingOccurrences(of: "[WIDTH]", with: "\(videoPlayerWidth)")
      videoPlayerMacroHeight = 480
      addLink = addLink.replacingOccurrences(of: "[HEIGHT]", with: "\(videoPlayerMacroHeight)")
        let videoPlayingViewHeightInt = Int(self.view.frame.height)
      let videoPlayingViewWidthInt = Int(self.view.frame.width)
      addLink = addLink.replacingOccurrences(of: "[[PLAYER_HEIGHT]]", with: "\(videoPlayingViewHeightInt)")
      addLink = addLink.replacingOccurrences(of: "[PLAYER_WIDTH]", with: "\(videoPlayingViewWidthInt)")
      if UserDefaults.standard.string(forKey:"countryCode") != nil {
        let countryCode = UserDefaults.standard.string(forKey:"countryCode")
        addLink = addLink.replacingOccurrences(of: "[COUNTRY]", with: countryCode!)
      }
      if UserDefaults.standard.string(forKey:"userAgent") != nil {
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")!
        let encodeduserAgent = String(format: "%@", userAgent.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        addLink =  addLink.replacingOccurrences(of: "[USER_AGENT]", with: "Mozilla%2F5.0+%28Linux%3B+Android+10%3B+SM-J400F+Build%2FQP1A.190711.020%3B+wv%29+AppleWebKit%2F537.36+%28KHTML%2C+like+Gecko%29+Version%2F4.0+Chrome%2F86.0.4240.110+Mobile+Safari%2F537.36")
      }
      let UDID = UserDefaults.standard.string(forKey:"UDID")!
      addLink = addLink.replacingOccurrences(of: "[UUID]", with: UDID)
      if UserDefaults.standard.string(forKey:"IPAddress") != nil {
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
              addLink = addLink.replacingOccurrences(of: "[IP_ADDRESS]", with:ipAddress)

      }

      let originalAppNameString = "HappiTV"
      let encodedAppNameUrl = String(format: "%@", originalAppNameString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[APP_NAME]", with: encodedAppNameUrl)

      if UserDefaults.standard.string(forKey:"latitude") != nil {
        let lattitude = UserDefaults.standard.string(forKey: "latitude")!
        addLink = addLink.replacingOccurrences(of: "[LATITUDE]", with: lattitude)
      }
      if UserDefaults.standard.string(forKey:"longitude") != nil {
        let longitude = UserDefaults.standard.string(forKey:"longitude")!
        addLink = addLink.replacingOccurrences(of: "[LONGITUDE]", with: longitude)
      }
      if UserDefaults.standard.string(forKey:"Idfa") != nil {
        let Idfa = UserDefaults.standard.string(forKey:"Idfa")!
        addLink = addLink.replacingOccurrences(of: "[DEVICE_IFA]", with: Idfa)
      }
      if UserDefaults.standard.string(forKey:"city") != nil {
        let city = UserDefaults.standard.string(forKey:"city")!
        addLink = addLink.replacingOccurrences(of: "[CITY]", with: city)
      }
      if UserDefaults.standard.string(forKey:"Geo_Type") != nil {
        let Geo_Type = UserDefaults.standard.string(forKey:"Geo_Type")!
        addLink = addLink.replacingOccurrences(of: "[GEO_TYPE]", with: Geo_Type)
      }

      addLink = addLink.replacingOccurrences(of: "[GDPR]", with: "0")
      addLink = addLink.replacingOccurrences(of: "[AUTOPLAY]", with: "1")
      addLink = addLink.replacingOccurrences(of: "[GDPR]", with: "0")
      if videoDescription != "" {
        let encodedvideoDescription = String(format: "%@",videoDescription.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        addLink = addLink.replacingOccurrences(of: "[DESCRIPTION]", with: encodedvideoDescription)
      }
      let originalDeviceType = "iOS"
      let encodedDeviceType = String(format: "%@",originalDeviceType.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[DEVICE_TYPE]", with: encodedDeviceType)
      let originalDevicemake = "Apple"
      let encodedDevicemake = String(format: "%@",originalDevicemake.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[DEVICE_MAKE]", with: encodedDevicemake)
      let deviceModel = UserDefaults.standard.string(forKey:"deviceModel")!
      let encodedDeviceModel = String(format: "%@", deviceModel.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      addLink = addLink.replacingOccurrences(of: "[DEVICE_MODEL]", with:encodedDeviceModel)
      let deviceId = UserDefaults.standard.string(forKey:"UDID")!
      addLink = addLink.replacingOccurrences(of: "[DEVICE_ID]", with:deviceId)
      addLink = addLink.replacingOccurrences(of: "[VIDEO_ID]", with:String(videoId))
      addLink = addLink.replacingOccurrences(of: "[CHANNEL_ID]", with:channelId)
      if video.video_duration != nil {
//        addLink = addLink.replacingOccurrences(of: "[TOTAL_DURATION]", with: video.video_duration!)
      }
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      addLink = addLink.replacingOccurrences(of: "[USER_ID]", with:user_id)
      if UserDefaults.standard.string(forKey:"CARRIER") != nil {
        let carrier = UserDefaults.standard.string(forKey:"CARRIER")
        let encodedCarrier = String(format: "%@", carrier!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        addLink = addLink.replacingOccurrences(of: "[CARRIER]", with: encodedCarrier)
      }
      if UserDefaults.standard.string(forKey:"NETWORK") != nil {
        let network = UserDefaults.standard.string(forKey:"NETWORK")!
        let encodedNetwork = String(format: "%@", network.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        addLink = addLink.replacingOccurrences(of: "[NETWORK]", with:encodedNetwork)
      }
      if UserDefaults.standard.string(forKey:"appVersion") != nil {
        let appVersion = UserDefaults.standard.string(forKey:"appVersion")!
        addLink = addLink.replacingOccurrences(of: "[APP_VERSION]", with:appVersion)
      }
      if UserDefaults.standard.string(forKey:"TYPE") != nil {
        let type = UserDefaults.standard.string(forKey:"TYPE")!
        addLink = addLink.replacingOccurrences(of: "[TYPE]", with:type)
      }
      if video.video_duration != nil {
//        addLink = addLink.replacingOccurrences(of: "[DURATION]", with:video.video_duration!)
      }
      addLink = addLink.replacingOccurrences(of: "[DNT]", with:""  + "0")
      addLink = addLink.replacingOccurrences(of: "[VPAID]", with:""  + "0")
      addLink = addLink.replacingOccurrences(of: "[VPAID]", with:"" + "0")
      addLink = addLink.replacingOccurrences(of: "[PL]", with:"" + "0")
      addLink = addLink.replacingOccurrences(of: "[LOCSOURCE]", with:"2")
      addLink = addLink.replacingOccurrences(of: "[DEVICE_ORIGIN]", with:"IA")
      addLink = addLink.replacingOccurrences(of: "[CACHEBUSTER]", with:"AA")
      if UserDefaults.standard.string(forKey:"languageId") != nil {
        let languageId = UserDefaults.standard.string(forKey:"languageId")!
        addLink = addLink.replacingOccurrences(of: "[LANGUAGE]", with:languageId)
      }
      if video.category_name != nil{
      if let category_name = self.video.category_name{
        if !category_name.isEmpty {
          var name = ""
          for categoryListArray in category_name {
            print(categoryListArray)
            name =  name + "," + (categoryListArray)

          }
          let keywords = String(name.dropFirst())
          let encodedAppStoreUrl = keywords.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
          addLink = addLink.replacingOccurrences(of: "[KEYWORDS]", with:encodedAppStoreUrl)

         print("encoded url",encodedAppStoreUrl)

        }
      }
      }
      let originalAppstoreString = "https://apps.apple.com/in/app/happitv/id1535463535"
      let encodedAppStoreUrl = originalAppstoreString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      addLink = addLink.replacingOccurrences(of: "[APP_STORE_URL]", with: encodedAppStoreUrl)

      if UserDefaults.standard.string(forKey:"currentTimeStamp") != nil {
        let currentTimeStamp = UserDefaults.standard.string(forKey:"currentTimeStamp")!
        addLink = addLink.replacingOccurrences(of: "[CACHEBUSTER]", with:currentTimeStamp)
      }
      print("addLink",addLink)


    }



}
