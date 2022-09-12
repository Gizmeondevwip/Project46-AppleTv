//
//  VideoModel.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 01/03/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import Foundation
import Mapper


struct VideoModel: Mappable {
    let season : Int?
    let watched_duration : Int?
    let watched_percentage : Int?
    let ad_link : String?
    let email : String?
    let first_name : String?
    let user_email : String?
    let payper_flag:Int?
    let rental_flag: Int?
    let user_image : String?
    let video_description : String?
    let description : String?
    let type : String?
    let video_id : Int?
    let video_name : String?
    let logo_thumb :String?
    let thumbnail_350_200 :String?
    let video_title : String?
    let thumbnail : String?
    let banner : String?
    let video_tag : String?
    let video_duration : Int?
    let duration_text : String?
    let view_count : Int?
    let user_id : Int?
    let live_link: String?
    let logo :String?
    let channel_name :String?
    let channel_id :Int?
    let live_flag :Int?
    let category :String?
    let categoryid :Int?
    let genre_icon :String?
    let language_id :Int?
    let language_name :String?
    let language_icon :String?
    var status :String?
    var liked_flag :Int?
    var query :String?
    var countryCode :String?
    var lat :Int?
    var lon :Int?
    var selected :Bool?
    var validity :Int?
    let show_id :Int?
    let show_name : String?
    let partnerCategoryName : String?
    let week : String?
    let genre_id :Int?
    let delete_status:Int?
    let rewarded_status:Int?
    let premium_flag:Int?
    let year : String?
    let name : String?
    let parental_control : String?
    let synopsis : String?
    let trailer : String?
    let show_cast: String?
    let director: String?
    let theme : String?
    let producer : String?
    let audio : String?
    let subtitle : String?
    let resolution : String?
    let rating : String?
    let part : String?
    let part_flag : Int?
    let image : String?
    let categoryname :String?
    let category_name : [String]?
    let video_durationadd : String?
    var videos :[VideoModel]?
    var shows :[VideoModel]?
    let audio_language_name  : String?
    let partner_id :String?
    let category_id : [Int]?
    var subtitles :[subtitleModel]?
    
    // Implement this initializer
    init(map: Mapper) throws {
        season = map.optionalFrom("season")
        watched_duration = map.optionalFrom("watched_duration")
        watched_percentage = map.optionalFrom("watched_percentage")
        type = map.optionalFrom("type")
        subtitles = map.optionalFrom("subtitles")
        logo_thumb = map.optionalFrom("logo_thumb")
        user_email = map.optionalFrom("user_email")
        payper_flag = map.optionalFrom("payper_flag")
        rental_flag = map.optionalFrom("rental_flag")
        thumbnail_350_200 = map.optionalFrom("thumbnail_350_200")
        ad_link = map.optionalFrom("ad_link")
        email = map.optionalFrom("email")
        first_name = map.optionalFrom("first_name")
        user_image = map.optionalFrom("user_image")
        video_description = map.optionalFrom("video_description")
        description = map.optionalFrom("description")
        name = map.optionalFrom("name")
        video_id = map.optionalFrom("video_id")
        video_name = map.optionalFrom("video_name")
        audio_language_name = map.optionalFrom("audio_language_name")
        partner_id = map.optionalFrom("partner_id")
        show_cast = map.optionalFrom("show_cast")
        director = map.optionalFrom("director")
        week = map.optionalFrom("week")
        video_title = map.optionalFrom("video_title")
        thumbnail = map.optionalFrom("thumbnail")
        banner = map.optionalFrom("banner")
        video_tag = map.optionalFrom("video_tag")
        video_duration = map.optionalFrom("video_duration")
        view_count = map.optionalFrom("view_count")
        user_id = map.optionalFrom("user_id")
        live_link = map.optionalFrom("live_link")
        logo = map.optionalFrom("logo")
        channel_name = map.optionalFrom("channel_name")
        channel_id = map.optionalFrom("channel_id")
        live_flag = map.optionalFrom("live_flag")
        category = map.optionalFrom("category")
        categoryid = map.optionalFrom("categoryid")
        genre_icon = map.optionalFrom("genre_icon")
        language_id = map.optionalFrom("language_id")
        language_name = map.optionalFrom("language_name")
        language_icon = map.optionalFrom("language_icon")
        status = "false"
        liked_flag = map.optionalFrom("liked_flag")
        query = map.optionalFrom("query")
        countryCode = map.optionalFrom("countryCode")
        lat = map.optionalFrom("lat")
        lon = map.optionalFrom("lon")
        selected = map.optionalFrom("selected")
        validity = map.optionalFrom("validity")
        show_id = map.optionalFrom("show_id")
        show_name = map.optionalFrom("show_name")
        genre_id = map.optionalFrom("genre_id")
        delete_status = map.optionalFrom("delete_status")
        rewarded_status = map.optionalFrom("rewarded_status")
        premium_flag = map.optionalFrom("premium_flag")
        //live_flag = map
      year = map.optionalFrom("year")
      parental_control = map.optionalFrom("parental_control")
      synopsis = map.optionalFrom("synopsis")
      trailer = map.optionalFrom("trailer")
      theme = map.optionalFrom("theme")
      producer = map.optionalFrom("producer")
      audio = map.optionalFrom("audio")
      subtitle = map.optionalFrom("subtitle")
      resolution = map.optionalFrom("resolution")
        rating = map.optionalFrom("rating")
        video_durationadd = map.optionalFrom("video_duration")
        category_id = map.optionalFrom("category_id")
      part = map.optionalFrom("part")
      part_flag = map.optionalFrom("part_flag")
      image = map.optionalFrom("image")
      categoryname = map.optionalFrom("categoryname")
    category_name = map.optionalFrom("category_name")
        partnerCategoryName = map.optionalFrom("category_name")
        videos = map.optionalFrom("videos")
        shows = map.optionalFrom("shows")
        duration_text = map.optionalFrom("duration_text")

    }
    
}
struct SubscriptionModel: Mappable {
    
    var sub_id :Int?
    var valid_from :String?
    var valid_to :String?
    var subscription_name :String?
    var subscription_type_name :String?
    var subscription_type_id :Int?
    var mode_of_payment : String?
    var price : Double?
    var symbol : String?
    
    init(map: Mapper) throws {
        
        sub_id = map.optionalFrom("sub_id")
        valid_from = map.optionalFrom("valid_from")
        valid_to = map.optionalFrom("valid_to")
        subscription_name = map.optionalFrom("subscription_name")
        subscription_type_name = map.optionalFrom("subscription_type_name")
        subscription_type_id = map.optionalFrom("subscription_type_id")
        mode_of_payment = map.optionalFrom("mode_of_payment")
        price = map.optionalFrom("price")
        symbol = map.optionalFrom("symbol")
    }
}
struct subtitleModel: Mappable {

  var language_name : String?
  var short_code : String?
    var code : String?
    var subtitle_url : String?

  init(map: Mapper) throws {
    language_name = map.optionalFrom("language_name")
    short_code = map.optionalFrom("short_code")
    code = map.optionalFrom("code")
    subtitle_url = map.optionalFrom("subtitle_url")
  }
}
