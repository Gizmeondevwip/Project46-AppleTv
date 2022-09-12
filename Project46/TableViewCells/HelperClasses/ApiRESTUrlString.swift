
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
    
 
    func getToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@fcm_token=%@&device_type=%@&app_bundle_id=%@&app_key=%@", GetToken,parameterDictionary["fcmToken"]!,parameterDictionary["device_type"]!,parameterDictionary["app_bundle_id"]!,parameterDictionary["app_key"]!)
        return urlString
    }
   
    func Register(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@user_email=%@&password=%@&first_name=%@&last_name=%@&phone=%@&device_id=%@&device_type=%@&login_type=%@&facebook_id=%@&verified=%@&c_code=%@&pubid=%@", RegisterApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!,parameterDictionary["first_name"]!,parameterDictionary["last_name"]!,parameterDictionary["phone"]!,parameterDictionary["device_id"]!,parameterDictionary["device_type"]!,parameterDictionary["login_type"]!,parameterDictionary["facebook_id"]!,parameterDictionary["verified"]!,parameterDictionary["c_code"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func Login(parameterDictionary:Dictionary<String,String>!) -> String! {
       
            let urlString = String(format:"%@user_email=%@&password=%@", LoginApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!)
            let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)


            print("loginnew",urlString)
             print("loginnewEncoded",escapedString)
            return escapedString
      
    }
    func getNewsDetails(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetNewsDetails
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["news-id"]!)
        print("getNewsDetails",replacedUrl)
        return replacedUrl
    }
    func getUserSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetUserSubscriptions

        return urlString
    }
    func getPartnerList(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = partnerList
        print("partnerList",urlString)
//        let urlString = String(format:"%@&pubid=%@", partnerList,parameterDictionary["pubid"]!)
        return urlString
    }
    func getHomeSearchResults(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@", GetSearchVideo,parameterDictionary["key"]!)
        print("searchUrl",urlString)
        return urlString
    }
    func getHomeSearchSuggestionResults(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@", GetSearchSuggestionVideo,parameterDictionary["key"]!)
        print("searchUrl",urlString)
        return urlString
    }
    
    func getvideoSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:GetvideoSubscriptions + "%@",parameterDictionary["vid"]!)
       
       
        print("getvideoSubscriptions url ",urlString)
        return urlString
        
    }
    func getWatchlist(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetWatchlistUpdated
        print("watchlisturl",urlString)
        return urlString
    }
    func ForgotPassword(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@user_email=%@",  ForgotpasswordApiUrl,parameterDictionary["user_email"]!)
        print("forgotassword",urlString)
        return urlString
    }
    
    func getCategories(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetCategories
        return urlString
    }
    func getPubID(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&app_bundle_id=%@&app_key=%@", GetPubID,parameterDictionary["app_publisher_bundle_id"]!,parameterDictionary["app_key"]!)
        print("pubid url",urlString)

        return urlString
    }
    
    func getFreeShows(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetFreeShows
        print("GetFreeShows",GetFreeShows)
        return urlString
    }
    
    func getThemes(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&device_type=%@&pubid=%@", GetThemes,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
  
    func getDianamicHomeVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        if parameterDictionary["offset"] == "0"{
            let urlString = GetDianamicHomeWithoutOffset
            print("dynmaicHomeVideo",urlString)
            return urlString

        }
        else{
            let urlString = String(format:GetDianamicHome + "%@",parameterDictionary["offset"]!)
            print("dynmaicHomeVideo",urlString)
            return urlString
        }

        
    }
    func getFeaturedVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetFeaturedVideos
        print("GetFeaturedVideos",urlString)
        return urlString
    }
    func getFilmOfTheDayVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = getFilmUrl
        print("getFilmOfTheDayVideos",urlString)
        return urlString
    }
    
    func getHomeNewArrivals(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = getHomeNewArrivalsApiUrl
        print("HomeNewArrivals",urlString)
        return urlString
      }
    func getAllChannels(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString =  GetAllChannels
        print("geallLivechannels",urlString)
        return urlString
    }
    func getChannelhome(parameterDictionary:Dictionary<String,String>!) -> String! {
             let urlString = GetHomeChannelvideo
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["vid"]!)
        print("GetHomeChannelvideo",replacedUrl)
        return replacedUrl
    }
    func GetPartnerByCategory(parameterDictionary:Dictionary<String,String>!) -> String! {
        
        let urlString = GetPartnerByCategory1
   let replacedUrl = urlString.replacingOccurrences(of: "partner_id", with: parameterDictionary["key"]!)
   print("GetPartnerByCategory1",replacedUrl)
        return replacedUrl
    }
    func getvideoAccordingToShows(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetShowNameData
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["show-id"]!)
        print("GetShowNameData",replacedUrl)
        return replacedUrl
    }
    func getvideoByCategory(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetvideoByCategory
        
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["key"]!)
        print("getvideoByCategory",replacedUrl)
        return replacedUrl
    }
    func getlogOUtUrl(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetLogOUtUrl
     
        return urlString
    }
    func generateLiveToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GenerateLiveToken)
        return urlString
        
    }
    func getWatchlistShows(parameterDictionary:Dictionary<String,String>!) -> String! {

        let urlString = String(format:GetWatchlistShows + "%@/%@",parameterDictionary["show-id"]!,parameterDictionary["watchlistflag"]!)
        print("GetWatchlistShows",urlString)
        return urlString
        
        

//       let urlString = String(format:"%@watchlistflag=%@&deletestatus=%@", GetWatchlistShows,parameterDictionary["show-id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["watchlistflag"]!,parameterDictionary["userId"]!,parameterDictionary["deletestatus"]!)
//       return urlString
     }
    func getWatchFlag(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = getWatchListFlag
        
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["show-id"]!)
        print("getWatchListFlag",replacedUrl)
        return replacedUrl
//             let urlString = String(format:"%@uid=%@&country_code=%@&device_type=%@&pubid=%@&show_id=%@", getWatchListFlag,parameterDictionary["userId"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["show-id"]!)
//             return urlString
         }
    func getSelectedVideo(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:GetSelectedVideo + "%@",parameterDictionary["vid"]!)
       
//        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["vid"]!)
        print("GetSelectedVideo",urlString)
        return urlString
    }
    func resendOtp(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString =  resendOtp1

        return urlString
    }
    func verifyOtp(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@otp=%@",verifyOtpFromEmail,parameterDictionary["otp"]!)
//
//        return urlString
       
        print("verifyOtpFromEmail",urlString)
        return urlString
    }
    func generateVideoToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&pubid=%@", GenerateVideoToken,parameterDictionary["pubid"]!)
        return urlString
    }
  func getUserDeleteApi(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetDeleteUserApi
    print("user delete url",urlString)
        return urlString
    }
}

