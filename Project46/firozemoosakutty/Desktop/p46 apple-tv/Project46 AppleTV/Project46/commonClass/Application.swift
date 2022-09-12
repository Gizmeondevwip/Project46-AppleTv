//
//  ActivityIndicator.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 03/09/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class Application {
    static var shared = Application()
    var userSubscriptionsArray = [SubscriptionModel]()
    var country_code: String?
    var publisherId: Int?
    var selectedVideoModel: VideoModel!
    var isFromRegister = Bool()
    var guestRegister = false
    var userSubscriptionStatus = Bool()
    var userSubscriptionVideoStatus = Bool()

    var APP_LAUNCH = true

    var app_bundle_id: String {
        let bundleID = Bundle.main.bundleIdentifier
        return bundleID!
     }
      var app_key: String {
      return "Project46TVOS"
    }
    var accessToken: String?
    
}



