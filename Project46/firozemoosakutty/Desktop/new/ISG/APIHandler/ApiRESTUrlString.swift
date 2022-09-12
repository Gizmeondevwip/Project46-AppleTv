
//
//  ApiRESTUrlString.swift
//  AlimonySwift
//
//  Created by Firoze Moosakutty on 09/02/18.
//  Copyright © 2018 Firoze Moosakutty. All rights reserved.
//

import Foundation

public class ApiRESTUrlString {
    let defaults = UserDefaults.standard
    
    func getLocatiionAndIp(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GetLocationAndIP)
        return urlString
    }
    
    func getToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&fcm_token=%@&device_type=%@&app_bundle_id=%@&app_key=%@", GetToken,parameterDictionary["user_id"]!,parameterDictionary["fcmToken"]!,parameterDictionary["device_type"]!,parameterDictionary["app_bundle_id"]!,parameterDictionary["app_key"]!)
        return urlString
    }
    
    func getChannels(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GetChannalApiUrl)
        return urlString
    }
    
    func getPopularChannels(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&device_type=%@&pubid=%@", GetPopularChannelApiUrl,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!
        )
        return urlString
    }
    
    func getCategories(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&device_type=%@&pubid=%@", GetCategories,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getvideoByCategory(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@&uid=%@&country_code=%@&device_type=%@&pubid=%@", GetvideoByCategory,parameterDictionary["key"]!,parameterDictionary["user_id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getHome(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@", getHomeApiUrl,parameterDictionary["country_code"]!)
        return urlString
    }
    
    func getHomePopularVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&country_code=%@&device_type=%@&pubid=%@", getHomePopularApiUrl,parameterDictionary["user_id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getvideoList(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@&uid=%@&country_code=%@&device_type=%@&pubid=%@", GetvideoList,parameterDictionary["channel_id"]!,parameterDictionary["user_id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!

        )
        return urlString
    }
    
    func getSimilarVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@vid=%@&uid=%@&country_code=%@&device_type=%@&pubid=%@", GetSimilarVideos,parameterDictionary["video_id"]!,parameterDictionary["user_id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getAllChannels(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&device_type=%@&pubid=%@", GetAllChannels,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!
        )
        return urlString
    }
    
    func getFBLogin(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@facebook_id=%@", FBloginApi,parameterDictionary["facebook_id"]!)
        return urlString
    }
    func Register(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@user_email=%@&password=%@&first_name=%@&last_name=%@&phone=%@&device_id=%@&device_type=%@&login_type=%@&facebook_id=%@&verified=%@&c_code=%@&pubid=%@", RegisterApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!,parameterDictionary["first_name"]!,parameterDictionary["last_name"]!,parameterDictionary["phone"]!,parameterDictionary["device_id"]!,parameterDictionary["device_type"]!,parameterDictionary["login_type"]!,parameterDictionary["facebook_id"]!,parameterDictionary["verified"]!,parameterDictionary["c_code"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func Login(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@user_email=%@&password=%@&pubid=%@", LoginApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func ForgotPassword(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@user_email=%@",  ForgotpasswordApiUrl,parameterDictionary["user_email"]!)
        return urlString
    }
    
    func getHomeSearchResults(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@&country_code=%@&device_type=%@&pubid=%@", GetSearchVideo,parameterDictionary["key"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getSearchResults(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@&country_code=%@", GetSearchChannel,parameterDictionary["key"]!,parameterDictionary["country_code"]!)
        return urlString
    }
    
    func getSearchlist(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@", GetSearchListApiUrl,parameterDictionary["country_code"]!)
        return urlString
    }
    
    func getMoreVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&vid=%@", GetMoreVideosUrl,parameterDictionary["publisher_id"]!,parameterDictionary["video_id"]!)
        return urlString
        
    }
    
    func getVideoByID(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@video_id=%@&video_title=%@&video_description=%@&video_name=%@", GetChannalApiUrl, parameterDictionary["video_id"]!, parameterDictionary["video_title"]!,parameterDictionary["video_description"]!,parameterDictionary["video_name"]!)
        return urlString
    }
    
    func likeDislikeVideo(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@vid=%@&uid=%@&liked=%@&device_type=%@&device_type=%@", LikeVideo,parameterDictionary["vid"]!,parameterDictionary["uid"]!,parameterDictionary["liked"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getWatchlist(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&country_code=%@&device_type=%@&pubid=%@", GetWatchlist,parameterDictionary["user_id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getIPAddressURL(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@/%@", IPAddressUrl,parameterDictionary["ip_address"]!)
        return urlString
    }
    
    func getLanguages(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GetLanguages)
        return urlString
    }
    
    func setLanguagePriority(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&lang_list=%@", SetLanguagePriority,parameterDictionary["uid"]!,parameterDictionary["lang_list"]!)
        return urlString
    }
    
    func generateToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&pubid=%@", GenerateToken,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func updateWatchList(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@vid=%@&uid=%@&device_type=%@&pubid=%@", UpdateWatchList,parameterDictionary["video_id"]!,parameterDictionary["user_id"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getFeaturedVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&country_code=%@&device_type=%@&pubid=%@", GetFeaturedVideos,parameterDictionary["user_id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
        
    }
    
    func getDianamicHomeVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&country_code=%@&device_type=%@&pubid=%@", GetDianamicHome,parameterDictionary["user_id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!
        )
        return urlString
    }
    
    func getUserLanguages(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&device_type=%@", GetUserLanguages,parameterDictionary["user_id"]!,parameterDictionary["device_type"]!)
        return urlString
        
    }
    
    func getAllLiveVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&device_type=%@@&pubid=%@", GetAllLiveVideos,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getShows(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&device_type=%@&pubid=%@", GetShows,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getShowVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@show_id=%@&country_code=%@&device_type=%@&pubid=%@", GetShowVideos,parameterDictionary["show-id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getSelectedVideo(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@vid=%@&uid=%@&country_code=%@&device_type=%@&pubid=%@", GetSelectedVideo,parameterDictionary["vid"]!,parameterDictionary["uid"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!
)
        return urlString
    }
    
    func getChannelhome(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@&uid=%@&country_code=%@&device_type=%@&pubid=%@", GetHomeChannelvideo,parameterDictionary["vid"]!,parameterDictionary["uid"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func generateLiveToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GenerateLiveToken)
        return urlString
        
    }
    func getYTVOD(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&country_code=%@&device_type=%@", getYoutubeVideo,parameterDictionary["uid"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!)
        return urlString
        
    }
    func getScheduleByDate(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = (String(format:"%@&start_utc=%@&end_utc=%@&country_code=%@&device_id=%@&channel_id=%@", GetScheduleByDate,parameterDictionary["start_utc"]!,parameterDictionary["end_utc"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["channel_id"]!)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return urlString
        
    }
    func getUserSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&device_id=%@&country_code=%@&pubid=%@", GetUserSubscriptions,parameterDictionary["user_id"]!,parameterDictionary["device_type"]!,parameterDictionary["country_code"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    func getvideoSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&device_id=%@&country_code=%@&pubid=%@&video_id=%@", GetvideoSubscriptions,parameterDictionary["uid"]!,parameterDictionary["device_type"]!,parameterDictionary["country_code"]!,parameterDictionary["pubid"]!,parameterDictionary["vid"]!)
        return urlString
    }
    func getchannelSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@channel_id=%@&uid=%@&device_id=%@&pubid=%@&country_code=%@", GetchannelSubscriptions,parameterDictionary["channel_id"]!,parameterDictionary["uid"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!)
        return urlString
    }
    func checkPhoneVerification(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&device_id=%@&pubid=%@&country_code=%@", CheckPhoneVerification,parameterDictionary["user_id"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!)
        return urlString
    }
    func verifyPhoneNumber(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&device_id=%@&pubid=%@&country_code=%@&phone=%@&c_code=%@", VerifyPhoneNumber,parameterDictionary["uid"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!,parameterDictionary["phone"]!,parameterDictionary["c_code"]!)
        return urlString
    }
    func subscriptionTransaction(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&device_type=%@&pubid=%@&country_code=%@&subscription_id=%@&transaction_type=%@&status=%@&amount=%@&mode_of_payment=%@&product_id=%@&purchase_token=%@", SubscriptionTransaction,parameterDictionary["uid"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!,parameterDictionary["subscription_id"]!,parameterDictionary["transaction_type"]!,parameterDictionary["status"]!,parameterDictionary["amount"]!,parameterDictionary["mode_of_payment"]!,parameterDictionary["product_id"]!,parameterDictionary["purchase_token"]!)
        print(urlString)
        return urlString
    }
    func getPubID(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&app_bundle_id=%@&app_key=%@", GetPubID,parameterDictionary["app_bundle_id"]!,parameterDictionary["app_key"]!)
        return urlString
    }
}

