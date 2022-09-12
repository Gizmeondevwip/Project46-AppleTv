//
//  ThemeManager.swift
//  HappiAppleTV
//
//  Created by GIZMEON on 04/02/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation

import UIKit

enum Theme: Int {

  case theme1, theme2

  var mainColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }

  var navigationBackgroundImage: UIImage? {
    return self == .theme1 ? UIImage(named: "navBackground") : nil
  }

  var tabBarBackgroundImage: UIImage? {
    return self == .theme1 ? UIImage(named: "tabBarBackground") : nil
  }

  var backgroundColor: UIColor {
    return UIColor().colorFromHexString("000000")
  }

  var secondaryColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }

  var titleTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }
  var subtitleTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }
  var textColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("000000")
    case .theme2:
      return UIColor().colorFromHexString("ffffff")
    }
  }
  var sideMenuTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor.darkGray
    case .theme2:
      return UIColor.lightGray
    }
  }

  var textfeildColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("000000")
    case .theme2:
      return UIColor().colorFromHexString("808080")
    }
  }
  var CgColor: CGColor {
    switch self {
    case .theme1:
      return  UIColor.white.cgColor
    case .theme2:
      return  UIColor.black.cgColor
    }
  }
  var PrivacyPolicyURL: String {
    return "https://gethappi.tv/policydarkmode"
  }
  var TermsAndConditionURL: String {
    return "https://gethappi.tv/termsofuse"
  }
  //screen change
  var Splashscreenimage: String {
    return "splashscreenimage"
  }
  var RightImage: String {
    return "rightArrow"
  }
  var emailAddress: String {
    return "support@gethappi.tv"
  }
  var logoutImage: String {
    return "TVExcelLogout"
  }
  var logoImage: String {
    return "LoginScreenImage"
  }
  var navigationControllerLogo: String {
    return "navigationControllerLogo"
  }
  var backImage: String {
    return "TVExcelBack"
  }
  var UIImageColor: UIColor {
    return UIColor().colorFromHexString("#55D2DC")
  }
  var appName: String {
    return "ISG"
  }
 var app_publisher_bundle_id: String {
    let bundleID = Bundle.main.bundleIdentifier
    return bundleID!
  }
  var app_key: String {
   return "ISGTVOS"
  }
  var grayImageColor: UIColor {
    return UIColor().colorFromHexString("1F1F1F")
  }
    var newBackgrondColor: UIColor {
       return UIColor().colorFromHexString("#141414")
     }
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
class ThemeManager {

  // ThemeManager
  static func currentTheme() -> Theme {
    if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
      return Theme(rawValue: storedTheme)!
    } else {
      return .theme2
    }
  }


}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
