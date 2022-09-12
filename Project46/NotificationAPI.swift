//
//  NotificationAPI.swift
//  Outdoor MAX

//
//  Created by GIZMEON on 05/10/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//


import Foundation
import UIKit
class NotificationApi {
    static func app_backGround_Event(){
        print("app_backGround_Event")
      var parameterDict: [String: String?] = [ : ]
      
      if UserDefaults.standard.string(forKey:"user_id") != nil {
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
          parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP06"
          
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
          parameterDict["app_id"] = app_id
        }
          if let channelid = UserDefaults.standard.string(forKey:"channelid") {
              parameterDict["channel_id"] = channelid
          }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        
        
        
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
                print("app_backGround_Event")
            }
          }
        }
      }
    }
    
    static func app_terminate_Event(){
        print("app_terminate_Event")
        var parameterDict: [String: String?] = [ : ]
       if UserDefaults.standard.string(forKey:"user_id") != nil {
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
          parameterDict["device_id"] = device_id
        }
          if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
          }
        parameterDict["event_type"] = "POP07"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
          parameterDict["app_id"] = app_id
        }
          if let channelid = UserDefaults.standard.string(forKey:"channelid") {
              parameterDict["channel_id"] = channelid
          }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
          if responseDictionary["error"] != nil {
            DispatchQueue.main.async {
            }
          } else {
            DispatchQueue.main.async {
                print("app_terminating_Event")
            }
          }
        }
      }
    }
   
}

