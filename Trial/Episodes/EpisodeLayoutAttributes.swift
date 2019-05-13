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
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let instance = super.copy(with: zone) as! EpisodeLayoutAttributes
        instance.radius = radius
        return instance
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return super.isEqual(object) && self.radius == (object as! EpisodeLayoutAttributes).radius
    }
}