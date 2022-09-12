//
//  LivePlayingViewController.swift
//  HappiAppleTV
//
//  Created by GIZMEON on 08/02/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//
import UIKit
import GoogleInteractiveMediaAds
import AVFoundation
import AVKit
import Reachability
class LivePlayingViewController: UIViewController,IMAAdsLoaderDelegate ,IMAAdsManagerDelegate {
    var token = ""
    var videoId = ""
    var videos = [VideoModel]()
    var categoryModel : VideoModel!
    var video: VideoModel!
    var isAdPlayback = false
    var isLandscape = false
    let playerItem: AVPlayerItem? = nil
    var videoHeight = CGFloat()
    var videoPlayerHeight = CGFloat()
    var adPositionsArray = Array<Float>()
    var channelNotificationId = Int()
    var channelVideoLink = ""

    var isPlaying = true
    var videoName = ""
    var videoTitle = ""
    static var addLink = " "
    var channelId: Int?
    var channelName = ""
    var liked = ""
    var theme = ""
    var programeTitle = ""
    var appStoreEncodedUrl = ""
    var videoStartTime = ""
    var categoryList = ""
    var videoDuration = Double()
    var watchUpdateFlag = false
    var isVideoPlaying = false

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
    var channelVideo: VideoModel!

    
    //google ads varaible
    static var AdTagURLString = " "
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    var avPlayer: AVPlayer? = AVPlayer()
    var contentPlayerLayer: AVPlayerLayer?
    var observer: Any!
    var playerViewController: AVPlayerViewController!
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    
    deinit {
       NotificationCenter.default.removeObserver(self)
     }

    var livelink = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        if livelink != "" {
          self.channelVideoLink = livelink
//            self.replaceMacros()
            self.setUpContentPlayer()
            self.setUpAdsLoader()
            self.requestAds()
            
          
        } else {
        
        }
//        self.collectionViewSelectedVideo()
    }
    
    func collectionViewSelectedVideo() {
      if channelVideo.premium_flag == 1 {
        if Application.shared.userSubscriptionStatus {
         
        } else {
          
        }
      }  else {
        self.initialView()
      }
    }
    func initialView() {
      self.isPresentController = true
      //self.contentView.isHidden = false
      if fromNotification == true {
        getchannelHomeVideo(indexpath: channelNotificationId)
      } else {
        getchannelHomeVideo(indexpath: channelVideo.channel_id!)

      }
    }
    func getchannelHomeVideo(indexpath: Int) {
   
      videos.removeAll()
      var parameterDict: [String: String?] = [ : ]
      parameterDict["vid"] = String(indexpath)
      parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      ApiCommonClass.Channelhome(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          self.videos = responseDictionary["data"] as! [VideoModel]
          if self.videos.count == 0 {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
              self.video = self.videos[0]
              if (self.video.premium_flag == 0) {
                self.didSelectNonPremiumVideo()
              } else {
                self.playVideoAfterSubscription()
              }
            }
          }
        }
      }
    }
    func didSelectNonPremiumVideo(){
      ApiCommonClass.generateLiveToken { (responseDictionary: Dictionary) in
        DispatchQueue.main.async {
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
              self.token = responseDictionary["Channels"] as! String
              self.SetupChannelDetails()
            }
          }
        }
      }
    }
    @objc func playVideoAfterSubscription() {
      SetupChannelDetails()
    }
    func SetupChannelDetails() {
      if video.channel_name != "" {
        self.navigationItem.title = video.channel_name
        channelName = self.video.channel_name!
        
      }
      if video.video_id != nil {
        self.videoId = "0"
      }
      if self.video.ad_link != nil {
        LivePlayingViewController.addLink = self.video.ad_link!
      }
      if let channel_id =  self.video.channel_id {
        self.channelId = channel_id
        videoId = "0"
      }
      if video.logo != nil {

        
      }
      self.replaceMacros()
      if video.live_link != nil {
        self.channelVideoLink = video.live_link!
          self.setUpContentPlayer()
          self.setUpAdsLoader()
          self.requestAds()
        
      } else {
      
      }

    }
    func setUpAdsLoader() {
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
    }
    func requestAds() {
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
        // Create an ad request with your ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: LivePlayingViewController.addLink,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        
        adsLoader.requestAds(with: request)
    }
   
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader.contentComplete()
      }
    func setUpContentPlayer() {
        print("setUpContentPlayer")
      // Load AVPlayer with path to your content.
        let contentUrl = URL(string: String(format:channelVideoLink))
       let headers = ["token": token]
       let asset: AVURLAsset = AVURLAsset(url: contentUrl!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
       let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
       avPlayer = AVPlayer(playerItem: playerItem)
      
         playerViewController = AVPlayerViewController()
         playerViewController.player = avPlayer
           contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
               NotificationCenter.default.addObserver(
                 self,
                 selector: #selector(LivePlayingViewController.playerDidFinish(_:)),
                 name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                 object: avPlayer?.currentItem);
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is LivePlayingViewController {
        print("topcontroller5",topController)
            commonClass.startActivityIndicator(onViewController: self)
//            showContentPlayer()
            //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            hideContentPlayer()
            playerViewController.player?.pause()
        }
        avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (progressTime) -> Void in
          let seconds = CMTimeGetSeconds(progressTime)
           
          if Int((seconds.truncatingRemainder(dividingBy: 60))) ==  0 && Int(seconds) != 0 {
          }
          
        }

     
    }
    
    func showContentPlayer() {
        print("setUpContentPlayer details")
        commonClass.stopActivityIndicator(onViewController: self)
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is LivePlayingViewController {
        print("topcontroller5",topController)

            self.addChild(playerViewController)
            playerViewController.view.frame = self.view.bounds
            self.view.insertSubview(playerViewController.view, at: 0)
            playerViewController.didMove(toParent:self)
              playerViewController.player?.play()            //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            hideContentPlayer()
            playerViewController.player?.pause()
        }
     
        if playerViewController?.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
          if let isPlaybackLikelyToKeepUp = playerViewController?.player?.currentItem?.isPlaybackLikelyToKeepUp {
            if  isPlaybackLikelyToKeepUp == false {
              print("isPlaybackLikelyToKeepUp",isPlaybackLikelyToKeepUp)

            } else {
              if self.watchUpdateFlag == false {
                self.watchUpdateFlag = true

              }
             }
          }
        }
     
    }

    func hideContentPlayer() {
      // The whole controller needs to be detached so that it doesn't capture  events from the remote.
      playerViewController.willMove(toParent:nil)
      playerViewController.view.removeFromSuperview()
      playerViewController.removeFromParent()
    }
    @objc func playerDidFinish(_ notification: Notification) {
        print("Video Finished")
//        self.channelendevent()
    }
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
        if (press.type == .select) {
            if isVideoPlaying {
                print("press play")
                self.isVideoPlaying = false
            }
            else{
                print("press pause")
                self.isVideoPlaying = true
            }
            print("selct is pressed")
            // Select is pressed
        }else {
            print("pressesEnded")
            
            super.pressesEnded(presses, with: event)
        }
        }
    }
    
    func channelStartEvent() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
      parameterDict["event_type"] = "POP02"

      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

      parameterDict["video_id"] = "0"
      if let channel_id = video.channel_id {
        parameterDict["channel_id"] = String(channel_id)
      }
      if let channelName = self.video.channel_name {
        parameterDict["video_title"] = channelName
      }
     
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        print("param for pop02",parameterDict)
      ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
          }
        }
      }
    }

    func channelPlayingEvent() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
      parameterDict["event_type"] = "POP03"
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["video_id"] = "0"
      if let channel_id = video.channel_id {
        parameterDict["channel_id"] = String(channel_id)
      }
      if let channelName = self.video.channel_name {
        parameterDict["video_title"] = channelName
      }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        print("param for pop03",parameterDict)

      ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
          }
        }
      }
    }
      
      func channelPauseEvent() {
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
          parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP04"

        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
          parameterDict["app_id"] = app_id
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

        parameterDict["video_id"] = "0"
        if let channel_id = video.channel_id {
          parameterDict["channel_id"] = String(channel_id)
        }
        if let channelName = self.video.channel_name {
          parameterDict["video_title"] = channelName
        }
       
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        print("param for pop04",parameterDict)

        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
            }
          }
        }
      }
      func channelResumeEvent() {
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
          parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP09"

        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
          parameterDict["app_id"] = app_id
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")

        parameterDict["video_id"] = "0"
        if let channel_id = video.channel_id {
          parameterDict["channel_id"] = String(channel_id)
        }
        if let channelName = self.video.channel_name {
          parameterDict["video_title"] = channelName
        }
       
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        print("param for pop09",parameterDict)

        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
            }
          }
        }
      }
    func channelPlayingError(error_code:String?,error_message:String?) {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
      parameterDict["event_type"] = "POP08"
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["video_id"] = "0"
      if let error_code = error_code {
        parameterDict["error_code"] = error_code
      }
      if let error_message = error_message {
        parameterDict["error_message"] = error_message
      }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
      if let channel_id = video.channel_id {
        parameterDict["channel_id"] = String(channel_id)
      }
      if let channelName = self.video.channel_name {
        parameterDict["video_title"] = channelName
      }
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        print("param for pop08",parameterDict)

      ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
          }
        }
      }
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        hideContentPlayer()
        playerViewController?.player!.pause()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(LivePlayingViewController.menuButtonAction(recognizer:)))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
    }

    @objc func menuButtonAction(recognizer:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
      
    func replaceMacros() {
      let bundleID = Bundle.main.bundleIdentifier
      if bundleID != nil {
        let originalBundleIdString = bundleID
        let encodedBundleIdUrl = originalBundleIdString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
      } else {
        let originalBundleIdString = "com.ios.projectfortysix"
        let encodedBundleIdUrl = originalBundleIdString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
      }
      videoPlayerWidth = 640
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[WIDTH]", with: "\(videoPlayerWidth)")
      videoPlayerMacroHeight = 480
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[HEIGHT]", with: "\(videoPlayerMacroHeight)")
        let videoPlayingViewHeightInt = Int(view.frame.width)
      let videoPlayingViewWidthInt = Int(self.view.frame.width)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[[PLAYER_HEIGHT]]", with: "\(videoPlayingViewHeightInt)")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[PLAYER_WIDTH]", with: "\(videoPlayingViewWidthInt)")
      if UserDefaults.standard.string(forKey:"countryCode") != nil {
        let countryCode = UserDefaults.standard.string(forKey:"countryCode")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[COUNTRY]", with: countryCode!)
      }
      if UserDefaults.standard.string(forKey:"userAgent") != nil {
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")!
        let encodeduserAgent = String(format: "%@", userAgent.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink =  LivePlayingViewController.addLink.replacingOccurrences(of: "[USER_AGENT]", with: "Mozilla%2F5.0+%28Linux%3B+Android+10%3B+SM-J400F+Build%2FQP1A.190711.020%3B+wv%29+AppleWebKit%2F537.36+%28KHTML%2C+like+Gecko%29+Version%2F4.0+Chrome%2F86.0.4240.110+Mobile+Safari%2F537.36")
      }
      let UDID = UserDefaults.standard.string(forKey:"UDID")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[UUID]", with: UDID)
      if UserDefaults.standard.string(forKey:"IPAddress") != nil {
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[IP_ADDRESS]", with:ipAddress)
         
      }
      
      let originalAppNameString = "HappiTV"
      let encodedAppNameUrl = String(format: "%@", originalAppNameString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[APP_NAME]", with: encodedAppNameUrl)

      if UserDefaults.standard.string(forKey:"latitude") != nil {
        let lattitude = UserDefaults.standard.string(forKey: "latitude")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[LATITUDE]", with: lattitude)
      }
      if UserDefaults.standard.string(forKey:"longitude") != nil {
        let longitude = UserDefaults.standard.string(forKey:"longitude")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[LONGITUDE]", with: longitude)
      }
      if UserDefaults.standard.string(forKey:"Idfa") != nil {
        let Idfa = UserDefaults.standard.string(forKey:"Idfa")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DEVICE_IFA]", with: Idfa)
      }
      if UserDefaults.standard.string(forKey:"city") != nil {
        let city = UserDefaults.standard.string(forKey:"city")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[CITY]", with: city)
      }
      if UserDefaults.standard.string(forKey:"Geo_Type") != nil {
        let Geo_Type = UserDefaults.standard.string(forKey:"Geo_Type")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[GEO_TYPE]", with: Geo_Type)
      }

        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[GDPR]", with: "0")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[AUTOPLAY]", with: "1")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[GDPR]", with: "0")
      if videoDescription != "" {
        let encodedvideoDescription = String(format: "%@",videoDescription.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DESCRIPTION]", with: encodedvideoDescription)
      }
      let originalDeviceType = "iOS"
      let encodedDeviceType = String(format: "%@",originalDeviceType.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DEVICE_TYPE]", with: encodedDeviceType)
      let originalDevicemake = "Apple"
      let encodedDevicemake = String(format: "%@",originalDevicemake.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DEVICE_MAKE]", with: encodedDevicemake)
      let deviceModel = "AppleTv"
        let encodedDeviceModel = String(format: "%@", deviceModel.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DEVICE_MODEL]", with:encodedDeviceModel)
      let deviceId = UserDefaults.standard.string(forKey:"UDID")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DEVICE_ID]", with:deviceId)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[VIDEO_ID]", with:String(videoId))
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[CHANNEL_ID]", with:String(channelId!))
      if video.video_duration != nil {
        let duration = String(video.video_duration! )
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[TOTAL_DURATION]", with: duration)
      }
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[USER_ID]", with:user_id)
      if UserDefaults.standard.string(forKey:"CARRIER") != nil {
        let carrier = UserDefaults.standard.string(forKey:"CARRIER")
        let encodedCarrier = String(format: "%@", carrier!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[CARRIER]", with: encodedCarrier)
      }
      if UserDefaults.standard.string(forKey:"NETWORK") != nil {
        let network = UserDefaults.standard.string(forKey:"NETWORK")!
        let encodedNetwork = String(format: "%@", network.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[NETWORK]", with:encodedNetwork)
      }
      if UserDefaults.standard.string(forKey:"appVersion") != nil {
        let appVersion = UserDefaults.standard.string(forKey:"appVersion")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[APP_VERSION]", with:appVersion)
      }
      if UserDefaults.standard.string(forKey:"TYPE") != nil {
        let type = UserDefaults.standard.string(forKey:"TYPE")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[TYPE]", with:type)
      }
      if video.video_duration != nil {
        let duration = String(video.video_duration! )
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DURATION]", with:duration)
      }
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DNT]", with:""  + "0")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[VPAID]", with:""  + "0")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[VPAID]", with:"" + "0")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[PL]", with:"" + "0")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[LOCSOURCE]", with:"2")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[DEVICE_ORIGIN]", with:"IA")
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[CACHEBUSTER]", with:"AA")
      if UserDefaults.standard.string(forKey:"languageId") != nil {
        let languageId = UserDefaults.standard.string(forKey:"languageId")!
        LivePlayingViewController.addLink = LivePlayingViewController.addLink.replacingOccurrences(of: "[LANGUAGE]", with:languageId)
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
            LivePlayingViewController.addLink =  LivePlayingViewController.addLink.replacingOccurrences(of: "[KEYWORDS]", with:encodedAppStoreUrl)

         print("encoded url",encodedAppStoreUrl)
         
        }
      }
      }
      let originalAppstoreString = "https://apps.apple.com/in/app/happitv/id1535463535"
      let encodedAppStoreUrl = originalAppstoreString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        LivePlayingViewController.addLink =  LivePlayingViewController.addLink.replacingOccurrences(of: "[APP_STORE_URL]", with: encodedAppStoreUrl)

      if UserDefaults.standard.string(forKey:"currentTimeStamp") != nil {
        let currentTimeStamp = UserDefaults.standard.string(forKey:"currentTimeStamp")!
        LivePlayingViewController.addLink =  LivePlayingViewController.addLink.replacingOccurrences(of: "[CACHEBUSTER]", with:currentTimeStamp)
      }
      print("addLink", LivePlayingViewController.addLink)
      

    }

}
extension LivePlayingViewController{
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        print("IMAAdsLoadedData")

        adsManager = adsLoadedData.adsManager
        adsManager.initialize(with: nil)
        adsManager.delegate = self
      
    }

    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
      print("Error loading ads: " + adErrorData.adError.message)
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is LivePlayingViewController {
        print("topcontroller5",topController)

            showContentPlayer()
            playerViewController.player?.play()
//              self.channelPlayingError(error_code: String(format: "%d", adErrorData.adError.code.rawValue), error_message: String(format: "%@", adErrorData.adError.message))       //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
        }
     
     
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
       
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is LivePlayingViewController {
        print("topcontroller5",topController)

            showContentPlayer()
            playerViewController.player?.play()
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
        }
       
      }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
      // Pause the content for the SDK to play ads.
        print("adsManagerDidRequestContentPause")
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is LivePlayingViewController {
        print("topcontroller5",topController)

            playerViewController.player?.pause()
            hideContentPlayer()
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
        }
      
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
      // Resume the content since the SDK is done playing ads (at least for now).
        print("adsManagerDidRequestContentResume")

        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is LivePlayingViewController {
        print("topcontroller5",topController)

            showContentPlayer()
            playerViewController.player?.play()
            //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
            playerViewController.player?.pause()
        }
    }
    
}
