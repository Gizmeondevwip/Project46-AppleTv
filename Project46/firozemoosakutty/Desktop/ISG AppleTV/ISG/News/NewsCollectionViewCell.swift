//
//  NewsCollectionViewCell.swift
//  RunwayTV
//
//  Created by GIZMEON on 13/06/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class NewsCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.layoutIfNeeded()
    }
}
