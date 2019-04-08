//
//  LayoutAttributes.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class LayoutAttributes: UICollectionViewLayoutAttributes {
    var timing: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let instance = super.copy(with: zone) as! LayoutAttributes
        instance.timing = timing
        return instance
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return super.isEqual(object) && self.timing == (object as! LayoutAttributes).timing
    }
}
