//
//  DianamicModel.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 15/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct DianamicModel: Mappable {
    var id :Int?
    var title :String?
    var data :[VideoModel]?
    
    init(map: Mapper) throws {
        id = map.optionalFrom("id")
        title = map.optionalFrom("title")
        data = map.optionalFrom("data")
    }
}
struct showByCategoryModel: Mappable {
    var category_id :Int?
    var category_name :String?
    var shows :[VideoModel]?
    
    init(map: Mapper) throws {
        category_id = map.optionalFrom("category_id")
        category_name = map.optionalFrom("category_name")
        shows = map.optionalFrom("shows")
    }
}
struct PartnerModel: Mappable {
    var partner_id :Int?
    var partner_name :String?
    var shows :[VideoModel]?
    
    init(map: Mapper) throws {
        partner_id = map.optionalFrom("partner_id")
        partner_name = map.optionalFrom("partner_name")
        shows = map.optionalFrom("shows")
    }
    
}
