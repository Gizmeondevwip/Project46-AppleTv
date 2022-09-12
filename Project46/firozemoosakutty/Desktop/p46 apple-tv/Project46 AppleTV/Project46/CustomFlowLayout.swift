//
//  CustomFlowLayout.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 04/09/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import Foundation

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let answer = super.layoutAttributesForElements(in: rect)!
        if !answer.isEmpty {
        for i in 1..<(answer.count ) {
            let currentLayoutAttributes: UICollectionViewLayoutAttributes = (answer[i])
            let prevLayoutAttributes: UICollectionViewLayoutAttributes = (answer[i - 1])
            let maximumSpacing = CGFloat(30.0)
            let origin = prevLayoutAttributes.frame.maxX
            
            if CGFloat(origin + maximumSpacing) + currentLayoutAttributes.frame.size.width < collectionViewContentSize.width {
                var frame: CGRect = currentLayoutAttributes.frame
                frame.origin.x = CGFloat(origin + maximumSpacing)
                currentLayoutAttributes.frame = frame
            }
        }
        }
        return answer
    }
  


}
