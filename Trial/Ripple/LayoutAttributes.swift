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
    
    var titleFontSize: CGFloat = 0
    
    var subtitleFontSize: CGFloat = 0
    
    var titlesBottom: CGFloat = 0
    
    var radius: CGFloat = 0
    
    var sceneState: RippleSceneState = .watching
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let instance = super.copy(with: zone) as! LayoutAttributes
        instance.timing = timing
        instance.titleFontSize = titleFontSize
        instance.subtitleFontSize = subtitleFontSize
        instance.titlesBottom = titlesBottom
        instance.radius = radius
        instance.sceneState = sceneState
        return instance
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return super.isEqual(object) && self.timing == (object as! LayoutAttributes).timing &&
        self.titleFontSize == (object as! LayoutAttributes).titleFontSize &&
        self.subtitleFontSize == (object as! LayoutAttributes).subtitleFontSize &&
        self.titlesBottom == (object as! LayoutAttributes).titlesBottom &&
        self.radius == (object as! LayoutAttributes).radius &&
        self.sceneState == (object as! LayoutAttributes).sceneState
    }
}
