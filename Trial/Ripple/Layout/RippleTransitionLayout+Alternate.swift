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
    private var calcuTemplate: LayoutCalcuTemplate {
        return self.vertex2Layout.first!.value.1.template
    }
    
    func updateCenterTriangle(_ new: [CGPoint], bary: [CGFloat]) {
        let P1 = new[0], P2 = new[1], P3 = new[2]
        
        let center1 = IndexPath(row: Int(P1.y), section: Int(P1.x))
        let layoutP1 = RippleLayout(theCenter: center1, theCenterPosition: centerForItem(at: center1), theTemplate: calcuTemplate)
        
        let center2 = IndexPath(row: Int(P2.y), section: Int(P2.x))
        let layoutP2 = RippleLayout(theCenter: center2, theCenterPosition: centerForItem(at: center2), theTemplate: layoutP1.template)
        
        let center3 = IndexPath(row: Int(P3.y), section: Int(P3.x))
        let layoutP3 = RippleLayout(theCenter: center3, theCenterPosition: centerForItem(at: center3), theTemplate: layoutP1.template)
        
        self.vertex2Layout.removeAll()
        self.vertex2Layout[layoutP1.center] = (bary[0], layoutP1)
        self.vertex2Layout[layoutP2.center] = (bary[1], layoutP2)
        self.vertex2Layout[layoutP3.center] = (bary[2], layoutP3)
    }
    
    func assembleThreeNewLayouts(moveTo: IndexPath?, layoutTemplate: LayoutCalcuTemplate) -> RippleTransitionLayout {
        var layouts = Array(self.vertex2Layout.values.map {$0.1})
        var layoutP1 = layouts[0], layoutP2 = layouts[1], layoutP3 = layouts[2]
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
        let toggledLayoutTemplate = calcuTemplate.nextOnScene()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnRotate() -> RippleTransitionLayout {
        let toggledLayoutTemplate = calcuTemplate.nextOnRotate()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnFullPortrait() -> RippleTransitionLayout {
        let toggledLayoutTemplate = calcuTemplate.nextOnFullPortrait()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnFullLandscape() -> RippleTransitionLayout {
        let toggledLayoutTemplate = calcuTemplate.nextOnFullLandscape()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnMove(_ index: IndexPath?) -> RippleTransitionLayout {
        return assembleThreeNewLayouts(moveTo: index, layoutTemplate: calcuTemplate)
    }
}
