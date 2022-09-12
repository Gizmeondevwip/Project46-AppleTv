//
//  ApiCommonClass.swift
//  AlimonySwift
//
//  Created by Firoze Moosakutty on 09/02/18.
//  Copyright © 2018 Firoze Moosakutty. All rights reserved.
//

import Foundation

public class ApiCommonClass {
    
    static func getLocatioAndIp(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["user_id"] = "user_id"
        let getChannelsApi = ApiRESTUrlString().getLocatiionAndIp(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        print("user_id",String(UserDefaults.standard.integer(forKey: "user_id")))
        if UserDefaults.standard.string(forKey:"fcmToken") != nil {
            parameterDict["fcmToken"] = UserDefaults.standard.string(forKey:"fcmToken")
        } else {
            parameterDict["fcmToken"] = ""
        }
        parameterDict["device_type"] = "ios-phone"
        parameterDict["app_bundle_id"] = "com.app.tvexcel"
        parameterDict["app_key"] = "5001"
        let getChannelsApi = ApiRESTUrlString().getToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
          
            if  responseDictionary["message"] as? String  == "authentication done " {
               if  responseDictionary["pubid"] as? String != "" {
                let pubid = responseDictionary["pubid"] as! Int
                UserDefaults.standard.set(pubid, forKey: "pubid")
                }
                let app_id = responseDictionary["app_id"] as! String
                UserDefaults.standard.set(app_id, forKey: "app_id")

                let banner_id = responseDictionary["banner_id"] as! String
                UserDefaults.standard.set(banner_id, forKey: "banner_id")

                let rewarded_id = responseDictionary["rewarded_id"] as! String
                UserDefaults.standard.set(rewarded_id, forKey: "rewarded_id")

                let interstitial_id = responseDictionary["interstitial_id"] as! String
                UserDefaults.standard.set(interstitial_id, forKey: "interstitial_id")


                let interstitial_status = responseDictionary["interstitial_status"] as! String
                UserDefaults.standard.set(interstitial_status, forKey: "interstitial_status")

                let mobpub_interstitial_status = responseDictionary["mobpub_interstitial_status"] as! String
                UserDefaults.standard.set(mobpub_interstitial_status, forKey: "mobpub_interstitial_status")


                let mobpub_interstitial_id = responseDictionary["mobpub_interstitial_id"] as! String
                UserDefaults.standard.set(mobpub_interstitial_id, forKey: "mobpub_interstitial_id")

                let mobpub_banner_id = responseDictionary["mobpub_banner_id"] as! String
                UserDefaults.standard.set(mobpub_banner_id, forKey: "mobpub_banner_id")
                
//                let mopub_rect_banner_id = responseDictionary["mopub_rect_banner_id"] as! String
//                UserDefaults.standard.set(mopub_rect_banner_id, forKey: "mopub_rect_banner_id")
                
                 //channelResponse["Channels"] = channelResponseArray as AnyObject
                 channelResponse["Channels"] = responseDictionary ["token"]
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getHome(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var parameterDict: [String: String?] = [ : ]
        parameterDict["user_id"] = "user_id"
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        let getChannelsApi = ApiRESTUrlString().getHome(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getCategories(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["user_id"] = ""
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getChannelsApi = ApiRESTUrlString().getCategories(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getvideoByCategory(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getChannelsApi = ApiRESTUrlString().getvideoByCategory(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getShowVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getChannelsApi = ApiRESTUrlString().getShowVideos(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func Register(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        
        ApiCallManager.apiCallREST(mainUrl: RegisterApi, httpMethod: "POST", headers: ["Content-Type":"application/json"], postData: JSONData) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func setLanguagePriority(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        
        ApiCallManager.apiCallREST(mainUrl: SetLanguagePriority, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken], postData: JSONData) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                channelResponse["Channels"]=responseDictionary["message"]
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func Login(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let loginApi = ApiRESTUrlString().Login(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: loginApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            
            callback(channelResponse)
        }
    }
    static func ForgotPassword(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let loginApi = ApiRESTUrlString().ForgotPassword(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: loginApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["message"]
                channelResponse["Channels"]=dataArray
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            
            callback(channelResponse)
        }
    }
    static func FBLogin(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        // var parameterDict: [String: String?] = [ : ]
        // parameterDict["user_id"] = "user_id"
        let loginApi = ApiRESTUrlString().getFBLogin(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: loginApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            
            callback(channelResponse)
        }
    }
    static func getAllChannels(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        // parameterDict["user_id"] = "user_id"
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getChannelsApi = ApiRESTUrlString().getAllChannels(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getPopularChannels(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getChannelsApi = ApiRESTUrlString().getPopularChannels(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getChannels(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["user_id"] = "user_id"
        let getChannelsApi = ApiRESTUrlString().getChannels(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getHomePopularVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        var parameterDict: [String: String?] = [ : ]
        parameterDict["key"] = "1"
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getChannelsApi = ApiRESTUrlString().getHomePopularVideos(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getvideoList(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getvideoList(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getSimilarVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        //var parameterDict: [String : String?] = [:]
        //parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getSimilarVideos(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    
    static func getVideoByID(callback:@escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [:]
        parameterDict["video_id"] = "1"
        parameterDict["video_title"] = "asd"
        parameterDict["video_description"] = "song"
        parameterDict["token"] = "videoplayback.mp4"
        let getStudioApi = ApiRESTUrlString().getChannels(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getStudioApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
        }
    }
    static func GetSelectedVideo(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getSelectedVideo(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getHomeSearchResults(searchText: String!,searchType: String,category: String!,liveflag: String, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        var parameterDict: [String : String?] = [ : ]
        parameterDict["key"] = searchText
        parameterDict["type"] = searchType
        parameterDict["category"] = category
        parameterDict["liveflag"] = liveflag
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getSearchResultsApi = ApiRESTUrlString().getHomeSearchResults(parameterDictionary: (parameterDict as! Dictionary<String, String>))
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber else { return }
            if status == 1 {// Create a user!
                if searchType == "channel"{
                    let dataArray = responseDictionary["channel_data"] as! [Dictionary<String, Any>]
                    for videoItem in dataArray {
                        let JSON: NSDictionary = videoItem as NSDictionary
                        let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                        channelResponseArray.append(videoModel)
                    }
                }else{
                    
                    let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                    for videoItem in dataArray {
                        let JSON: NSDictionary = videoItem as NSDictionary
                        let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                        channelResponseArray.append(videoModel)
                    }
                }
                
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getSearchResults(searchText: String!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        var parameterDict: [String : String?] = [ : ]
        parameterDict["key"] = searchText
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        let getSearchResultsApi = ApiRESTUrlString().getSearchResults(parameterDictionary: (parameterDict as! Dictionary<String, String>))
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getSearchlist(callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        var parameterDict: [String: String?] = [: ]
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        let getSearchResultsApi = ApiRESTUrlString().getSearchlist(parameterDictionary: (parameterDict as! Dictionary<String, String>))
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber else { return }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getMoreVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        //        let parameterDict: [String : String?] = [:]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getMoreVideos(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getLikedDislikedVideo(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        //        let parameterDict: [String : String?] = [:]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().likeDislikeVideo(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                channelResponse["Channels"]=responseDictionary["message"]
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getWatchList(callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        var parameterDict: [String : String?] = [ : ]
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getWatchList = ApiRESTUrlString().getWatchlist(parameterDictionary: (parameterDict as! Dictionary<String, String>))
        ApiCallManager.apiCallREST(mainUrl: getWatchList!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getLanguages(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let parameterDict: [String: String?] = [ : ]
        let getLanguagesApi = ApiRESTUrlString().getLanguages(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func generateToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getLanguagesApi = ApiRESTUrlString().generateToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"]
                
                channelResponse["Channels"]=dataArray
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func updateWatchList(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        //let _: [String : String?] = [:]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().updateWatchList(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                
                channelResponse["Channels"]=responseDictionary["message"]
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getFeaturedVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getChannelsApi = ApiRESTUrlString().getFeaturedVideos(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getShows(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getChannelsApi = ApiRESTUrlString().getShows(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getAllLiveVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getChannelsApi = ApiRESTUrlString().getAllLiveVideos(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getDianamicHomeVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var parameterDict: [String: String?] = [ : ]
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        let getChannelsApi = ApiRESTUrlString().getDianamicHomeVideos(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: nil, postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [DianamicModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: DianamicModel = DianamicModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getUserLanguages(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["device_type"] = "ios-phone"
        let getChannelsApi = ApiRESTUrlString().getUserLanguages(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getGustUserId(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        ApiCallManager.apiCallREST(mainUrl: GetGustUserLogin, httpMethod: "POST", headers: ["Content-Type":"application/json"], postData: JSONData) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            if let status: Int = responseDictionary["success"] as? Int, status == 1 {
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
                
            } else {
                channelResponse["error"] = "An error occurred, please try again later" as AnyObject
            }
            callback(channelResponse)
        }
    }
    
    static func getGustUserStaus(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        
        ApiCallManager.apiCallREST(mainUrl: LoginRemoval, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken], postData: JSONData) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                if responseDictionary["data"] != nil {
                    let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                    for videoItem in dataArray {
                        let JSON: NSDictionary = videoItem as NSDictionary
                        let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                        channelResponseArray.append(videoModel)
                    }
                    
                    channelResponse["Channels"]=channelResponseArray as AnyObject
                } else {
                    channelResponse["error"] = "Error" as AnyObject
                }
            } else {
                channelResponse["error"] = responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func Channelhome(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getChannelhome(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func generateLiveToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        let parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getLanguagesApi = ApiRESTUrlString().generateLiveToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"]
                
                channelResponse["Channels"]=dataArray
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getYTVOD(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        
        let getChannelsApi = ApiRESTUrlString().getYTVOD(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [youtubeModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                // Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: youtubeModel = youtubeModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getScheduleByDate(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getScheduleByDate(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [ProgramModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: ProgramModel = ProgramModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getUserSubscriptions(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getChannelsApi = ApiRESTUrlString().getUserSubscriptions(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [SubscriptionModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: SubscriptionModel = SubscriptionModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    
    static func getvideoSubscriptions(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getvideoSubscriptions(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoSubscriptionModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoSubscriptionModel = VideoSubscriptionModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getchannelSubscriptions(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().getchannelSubscriptions(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [ChannelSubscriptionModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: ChannelSubscriptionModel = ChannelSubscriptionModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func checkPhoneVerification(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getChannelsApi = ApiRESTUrlString().checkPhoneVerification(parameterDictionary: parameterDict as? Dictionary<String, String>)
        ApiCallManager.apiCallREST(mainUrl: getChannelsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [PhoneVerifiedModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: PhoneVerifiedModel = PhoneVerifiedModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func verifyPhoneNumber(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let getSearchResultsApi = ApiRESTUrlString().verifyPhoneNumber(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                channelResponse["Channels"] = responseDictionary["success"]
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func subscriptionTransaction(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        ApiCallManager.apiCallREST(mainUrl: SubscriptionTransaction, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken], postData: JSONData) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                channelResponse["Channels"] = responseDictionary["success"]

            } else {
                channelResponse["error"] = responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getPubId() {
        var parameterDictionary: [String: String?] = [ : ]
        parameterDictionary["app_bundle_id"] = "999"
        parameterDictionary["app_key"] = "111"
        let getPubID = ApiRESTUrlString().getPubID(parameterDictionary: (parameterDictionary as! Dictionary<String, String>))
        ApiCallManager.apiCallREST(mainUrl: getPubID!, httpMethod: "POST", headers: ["Content-Type":"application/json"], postData: nil) { (responseDictionary: Dictionary) in
            guard let pubid = responseDictionary["pubid"] else {
                return
            }
            UserDefaults.standard.set(pubid, forKey: "pubid")
    }
}
}
