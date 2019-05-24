//
//  RippleTransitionLayout+Transform.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension RippleTransitionLayout {
    
    func assembleThreeNewLayouts(moveTo: IndexPath?, layoutTemplate: LayoutCalcuTemplate) -> RippleTransitionLayout {
        var layoutP1 = self.layoutP1, layoutP2 = self.layoutP2, layoutP3 = self.layoutP3
        if centerItem == layoutP2.center {
            swap(&layoutP1, &layoutP2)
        } else if centerItem == layoutP3.center {
            swap(&layoutP1, &layoutP3)
        }
        
        var center1, center2, center3: IndexPath
        if let moveTo = moveTo {
            (center1, center2, center3) = defaultIndexTriangleAround(moveTo, maxRow: ytRows, maxCol: ytCols)
        } else {
            (center1, center2, center3) = (layoutP1.center, layoutP2.center, layoutP3.center)
        }
        
        let newPositionForCenter1 = layoutTemplate.uiTemplates.estimatedCenterFor(item: center1)
        let toggledLayoutP1 = RippleLayout(theCenter: center1, theCenterPosition: newPositionForCenter1, theTemplate: layoutTemplate)
        let toggledLayoutP2 = RippleLayout(theCenter: center2, theCenterPosition: toggledLayoutP1.centerOf(center2), theTemplate: layoutTemplate)
        let toggledLayoutP3 = RippleLayout(theCenter: center3, theCenterPosition: toggledLayoutP1.centerOf(center3), theTemplate: layoutTemplate)
        
        return RippleTransitionLayout(layoutP1: toggledLayoutP1, layoutP2: toggledLayoutP2, layoutP3: toggledLayoutP3, uiTemplates: layoutTemplate.uiTemplates)
    }
    
    override var collectionViewContentSize: CGSize {
        return uiTemplates.contentSize
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return centerForItem(at: centerItem) - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
    }
    
    // Wrapper for LayoutCalcuTemplate
    // Assembler for three rippple layouts
    func nextOnScene() -> RippleTransitionLayout {
        let toggledLayoutTemplate = layoutP1.template.nextOnScene()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnRotate() -> RippleTransitionLayout {
        let toggledLayoutTemplate = layoutP1.template.nextOnRotate()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnFullPortrait() -> RippleTransitionLayout {
        let toggledLayoutTemplate = layoutP1.template.nextOnFullPortrait()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnFullLandscape() -> RippleTransitionLayout {
        let toggledLayoutTemplate = layoutP1.template.nextOnFullLandscape()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnMove(_ index: IndexPath?) -> RippleTransitionLayout {
        return assembleThreeNewLayouts(moveTo: index, layoutTemplate: layoutP1.template)
    }
}
