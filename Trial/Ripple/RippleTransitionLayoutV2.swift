//
//  RippleTransitionLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

let initialCenter1 = IndexPath(row: 2, section: 2)
let initialPosition1 = CGPoint(x: LayoutCalcuTemplate.watch.dXOf(dCol: initialCenter1.section, dRow: initialCenter1.row) + 200, y: LayoutCalcuTemplate.watch.dYOf(initialCenter1.section) + 200)
let initialLayout1 = RippleLayout(theCenter: initialCenter1, theCenterPosition: initialPosition1, theTemplate: LayoutCalcuTemplate.watch)

extension RippleTransitionLayout: TransitionalResource {
    
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
    
    func nextOnStagedFull() -> RippleTransitionLayout {
        let toggledLayoutTemplate = layoutP1.template.nextOnStagedFull()
        return assembleThreeNewLayouts(moveTo: nil, layoutTemplate: toggledLayoutTemplate)
    }
    
    func nextOnMove(_ index: IndexPath?) -> RippleTransitionLayout {
        return assembleThreeNewLayouts(moveTo: index, layoutTemplate: layoutP1.template)
    }
    
    typealias Item = RippleTransitionLayout
    
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
        
        let toggledLayoutP1 = RippleLayout(theCenter: center1, theCenterPosition: layoutP1.centerOf(center1), theTemplate: layoutTemplate)
        let toggledLayoutP2 = RippleLayout(theCenter: center2, theCenterPosition: layoutP1.centerOf(center2), theTemplate: layoutTemplate)
        let toggledLayoutP3 = RippleLayout(theCenter: center3, theCenterPosition: layoutP1.centerOf(center3), theTemplate: layoutTemplate)
        
        return RippleTransitionLayout(layoutP1: toggledLayoutP1, layoutP2: toggledLayoutP2, layoutP3: toggledLayoutP3, uiTemplates: layoutTemplate.uiTemplates)
    }
}

class RippleTransitionLayout: UICollectionViewLayout {
    private var layoutP1: RippleLayout
    
    private var layoutP2: RippleLayout
    
    private var layoutP3: RippleLayout
    
    var centerTriangle: (CGPoint, CGPoint, CGPoint)
    
    var baryCentrics: [CGFloat]
    
    var centerItem: IndexPath {
        let position = indexOfMax(baryCentrics)
        if position == 0 {
            return IndexPath(centerTriangle.0)
        } else if position == 1 {
            return IndexPath(centerTriangle.1)
        } else {
            return IndexPath(centerTriangle.2)
        }
    }
    
    var uiTemplates: UIMetricTemplate
    
    var shouldPagedMove: Bool {
        return rippleViewStore.state.scene == .watching
    }
    
    static var genesisLayout: RippleTransitionLayout {
        let triangle = defaultIndexTriangleAround(IndexPath(row: 2, section: 2), maxRow: ytRows, maxCol: ytCols)
        
        let isPortrait = UIScreen.main.bounds.height > UIScreen.main.bounds.width
        let calcu = isPortrait ? LayoutCalcuTemplate.surf : LayoutCalcuTemplate.surfLand
        
        let layoutP1 = RippleLayout(theCenter: triangle.0, theCenterPosition: CGPoint(x: 2000, y: 2000), theTemplate: calcu)
        let layoutP2 = RippleLayout(theCenter: triangle.1, theCenterPosition: layoutP1.centerOf(triangle.1), theTemplate: calcu)
        let layoutP3 = RippleLayout(theCenter: triangle.2, theCenterPosition: layoutP1.centerOf(triangle.2), theTemplate: calcu)
        
        let template = isPortrait ? UIMetricTemplate.surf : UIMetricTemplate.surfLand
        return RippleTransitionLayout(layoutP1: layoutP1, layoutP2: layoutP2, layoutP3: layoutP3, uiTemplates: template)
    }
    
    init(layoutP1: RippleLayout, layoutP2: RippleLayout, layoutP3: RippleLayout, uiTemplates: UIMetricTemplate) {
        self.layoutP1 = layoutP1
        self.layoutP2 = layoutP2
        self.layoutP3 = layoutP3
        self.centerTriangle = (CGPoint(layoutP1.center), CGPoint(layoutP2.center), CGPoint(layoutP3.center))
        self.baryCentrics = [1, 0, 0]
        self.lastCenterP = layoutP1.center
        self.uiTemplates = uiTemplates
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func getToggledLayout() -> RippleTransitionLayout {
        var layoutP1 = self.layoutP1, layoutP2 = self.layoutP2, layoutP3 = self.layoutP3
        if centerItem == layoutP2.center {
            swap(&layoutP1, &layoutP2)
        } else if centerItem == layoutP3.center {
            swap(&layoutP1, &layoutP3)
        }
        
        let toggledTemplate = layoutP1.template.toggledTemplate()
        let toggledLayoutP1 = RippleLayout(theCenter: layoutP1.center, theCenterPosition: layoutP1.centerPosition, theTemplate: toggledTemplate)
        let toggledLayoutP2 = RippleLayout(theCenter: layoutP2.center, theCenterPosition: layoutP1.centerOf(layoutP2.center), theTemplate: toggledTemplate)
        let toggledLayoutP3 = RippleLayout(theCenter: layoutP3.center, theCenterPosition: layoutP1.centerOf(layoutP3.center), theTemplate: toggledTemplate)
        
        return RippleTransitionLayout(layoutP1: toggledLayoutP1, layoutP2: toggledLayoutP2, layoutP3: toggledLayoutP3, uiTemplates: uiTemplates.toggled())
    }
    
    // 中心的 item
    @objc var lastCenterP: IndexPath
    
    func viewPortCenterChanged() {
        if let newCenterTriangle = reComputeCenterTriangle() {
            if newCenterTriangle != centerTriangle {
                updateCenterTriangle(newCenterTriangle)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes123 = [layoutP1.layoutAttributesForItem(at: indexPath)!, layoutP2.layoutAttributesForItem(at: indexPath)!, layoutP3.layoutAttributesForItem(at: indexPath)!]
        
        let result = LayoutAttributes(forCellWith: indexPath)
        result.frame = attributes123[0].frame * baryCentrics[0] + attributes123[1].frame * baryCentrics[1] + attributes123[2].frame * baryCentrics[2]
        result.timing = attributes123[0].timing * baryCentrics[0] + attributes123[1].timing * baryCentrics[1] + attributes123[2].timing * baryCentrics[2]
        
        result.titleFontSize = uiTemplates.titleFontSize
        result.subtitleFontSize = uiTemplates.subtitleFontSize
        result.titlesBottom = uiTemplates.titlesBottom
        result.radius = uiTemplates.radius
        result.sceneState = rippleViewStore.state.scene
        #if VERBOSE
        if indexPath == IndexPath(row: 2, section: 2) {
            print("\(collectionView!.viewPortCenter), \(layoutP1.centerPosition), \(layoutP2.centerPosition), \(layoutP3.centerPosition)")
        }
        #endif
        return result
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var r =  [UICollectionViewLayoutAttributes]()
        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
            (row, col, _) in
            let a = layoutAttributesForItem(at: IndexPath(row: row, section: col))
            if a?.frame.intersects(rect) == true {
                r.append(a!)
            }
        }
        return r
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 5000, height: 5000)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func centerOf(item: CGPoint) -> CGPoint {
        let index = IndexPath(row: Int(item.y), section: Int(item.x))
        let frame = layoutAttributesForItem(at: index)!.frame
        return CGPoint(x: frame.midX, y: frame.midY)
    }
    
    private func reComputeCenterTriangle() -> (CGPoint, CGPoint, CGPoint)?{
        var centerTriangle: (CGPoint, CGPoint, CGPoint)?
        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
            (row, col, stop) in
            for indexTriangle in indexTrianglesAround(CGPoint(x: row, y: col)) {
                let triangle = (centerOf(item: indexTriangle.0), centerOf(item: indexTriangle.1), centerOf(item: indexTriangle.2))
                let theBarycentric = barycentricOf(collectionView!.viewPortCenter, P1: triangle.0, P2: triangle.1, P3: triangle.2)
                if theBarycentric.allSatisfy({ $0 >= 0 }) {
                    centerTriangle = indexTriangle
                    baryCentrics = theBarycentric
                    stop = true
                    break
                }
            }
        }
        return centerTriangle
    }
    
    private func updateCenterTriangle(_ new: (CGPoint, CGPoint, CGPoint)) {
        centerTriangle = new
        let P1 = centerTriangle.0, P2 = centerTriangle.1, P3 = centerTriangle.2
        
        let center1 = IndexPath(row: Int(P1.y), section: Int(P1.x))
        layoutP1 = RippleLayout(theCenter: center1, theCenterPosition: layoutP1.centerOf(center1), theTemplate: layoutP1.template)
        
        let center2 = IndexPath(row: Int(P2.y), section: Int(P2.x))
        layoutP2 = RippleLayout(theCenter: center2, theCenterPosition: layoutP1.centerOf(center2), theTemplate: layoutP1.template)
        
        let center3 = IndexPath(row: Int(P3.y), section: Int(P3.x))
        layoutP3 = RippleLayout(theCenter: center3, theCenterPosition: layoutP1.centerOf(center3), theTemplate: layoutP1.template)
        
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let proposedCenter = proposedContentOffset + CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
        var minDistance = CGFloat(Int.max)
        var minCenter = CGPoint.zero
        var minIndex = lastCenterP
        for indexPath in nearestFiveTo(lastCenterP, maxRow: ytRows, maxCol: ytCols) {
            let center = centerOf(item: CGPoint(indexPath))
            let distance = distanceBetween(left: center, right: proposedCenter)
            if distance < minDistance {
                minDistance = distance
                minCenter = center
                minIndex = indexPath
            }
        }
        let r = minCenter - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
        
        if shouldPagedMove {
            lastCenterP = minIndex
            return r
        } else {
            lastCenterP = centerItem
            return proposedContentOffset
        }
        
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return centerOf(item: CGPoint(centerItem)) - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
    }
    
    
    private var maxRow: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    private var maxCol: Int {
        return collectionView!.numberOfSections
    }
}


