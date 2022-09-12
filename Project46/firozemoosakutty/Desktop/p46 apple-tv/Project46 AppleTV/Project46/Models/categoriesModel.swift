//
//  categoriesModel.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 18/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct categoriesModel: Mappable {

  var category_name : String?
  var category_id : Int?

  init(map: Mapper) throws {
    category_name = map.optionalFrom("category_name")
    category_id = map.optionalFrom("category_id")
  }
}

