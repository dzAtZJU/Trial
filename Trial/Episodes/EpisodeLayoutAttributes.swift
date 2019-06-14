//
//  LayoutAttributes.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class EpisodeLayoutAttributes: UICollectionViewLayoutAttributes {
    var radius: CGFloat = 0
    
    var hideContent = true
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let instance = super.copy(with: zone) as! EpisodeLayoutAttributes
        instance.radius = radius
        instance.hideContent = hideContent
        return instance
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let object = object as! EpisodeLayoutAttributes
        return super.isEqual(object) && self.radius == object.radius && self.hideContent == object.hideContent
    }
}
