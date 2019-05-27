//
//  RippleTransitionLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class RippleTransitionLayout: UICollectionViewLayout {
    var layoutP1: RippleLayout
    
    var layoutP2: RippleLayout
    
    var layoutP3: RippleLayout
    
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
        let template = isPortrait ? UIMetricTemplate.surf : UIMetricTemplate.surfLand
        
        let layoutP1 = RippleLayout(theCenter: triangle.0, theCenterPosition: template.estimatedCenterFor(item: triangle.0), theTemplate: calcu)
        let layoutP2 = RippleLayout(theCenter: triangle.1, theCenterPosition: layoutP1.centerOf(triangle.1), theTemplate: calcu)
        let layoutP3 = RippleLayout(theCenter: triangle.2, theCenterPosition: layoutP1.centerOf(triangle.2), theTemplate: calcu)
        
        
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
        return result
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var r = [UICollectionViewLayoutAttributes]()
        for row in 0..<ytRows {
            for col in 0..<ytCols {
                let l = layoutAttributesForItem(at: IndexPath(row: row, section: col))
                if l != nil {
                    r.append(l!)
                }
            }
        }
        return r
        
//        var visited = Set<IndexPath>()
//        var attributes = [UICollectionViewLayoutAttributes]()
//        dfs(node: centerItem, maxRow: maxRow, maxCol: maxCol, visited: &visited, rect: rect, attributes: &attributes)
//        return attributes
    }
    
    func dfs(node: IndexPath, maxRow: Int, maxCol: Int, visited: inout Set<IndexPath>, rect: CGRect, attributes: inout [UICollectionViewLayoutAttributes]) {
        visited.insert(node)
        
        let frame = frameForItem(at: node)
        if !rect.intersects(frame) {
            return
        }
        
        if let attribute = layoutAttributesForItem(at: node) {
            attributes.append(attribute)
        }
        
        for neighbor in eightNeighborsOf(item: node, maxRow: maxRow, maxCol: maxCol) {
            if !visited.contains(neighbor) {
                dfs(node: neighbor, maxRow: maxRow, maxCol: maxCol, visited: &visited, rect: rect, attributes: &attributes)
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func isViewCenterIn(indexTriangle: (CGPoint, CGPoint, CGPoint)) -> [CGFloat]? {
        let triangle = (centerForItem(at: IndexPath(indexTriangle.0)), centerForItem(at: IndexPath(indexTriangle.1)), centerForItem(at: IndexPath(indexTriangle.2)))
        let newBarycentric = barycentricOf(collectionView!.viewPortCenter, P1: triangle.0, P2: triangle.1, P3: triangle.2)
        let threshold: CGFloat = rippleViewStore.state.scene == .watching ? -0.02 : 0 // To soften Numeric effect
        if newBarycentric.allSatisfy({ $0 >= threshold }) {
            return newBarycentric
        }
        
        return nil
    }
    
    private func reComputeCenterTriangle() -> (CGPoint, CGPoint, CGPoint)? {
        var nextCenterTriangle: (CGPoint, CGPoint, CGPoint)?
        
        for indexTriangle in eightTrianglesAround(centerTriangle) {
            if let newBarycentric = isViewCenterIn(indexTriangle: indexTriangle) {
                nextCenterTriangle = indexTriangle
                baryCentrics = newBarycentric
                return nextCenterTriangle
            }
        }
        
        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
            (row, col, stop) in
            for indexTriangle in indexTrianglesAround(CGPoint(x: row, y: col), maxRow: ytRows, maxCol: ytCols) {
                if let newBarycentric = isViewCenterIn(indexTriangle: indexTriangle) {
                    nextCenterTriangle = indexTriangle
                    baryCentrics = newBarycentric
                    stop = true
                    break
                }
            }
        }
        
        return nextCenterTriangle
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
        if !shouldPagedMove {
            return proposedContentOffset
        }
        
//        if let translate = collectionView?.panGestureRecognizer.translation(in: collectionView), abs(translate.x) < 5 && abs(translate.y) < 5 {
//            return centerOf(item: CGPoint(centerItem)) - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
//        }
        
        let proposedCenter = proposedContentOffset + CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
        var minDistance = CGFloat(Int.max)
        var minCenter = CGPoint.zero
        var minIndex = lastCenterP
        let candidates = nearestFiveTo(lastCenterP, maxRow: ytRows, maxCol: ytCols) + fourDiagonalNeighborsOf(lastCenterP, maxRow: ytRows, maxCol: ytCols)
        print(candidates)
        for indexPath in candidates {
            let center = centerForItem(at: indexPath)
            let distance = distanceBetween(left: center, right: proposedCenter)
            if distance < minDistance {
                minDistance = distance
                minCenter = center
                minIndex = indexPath
            }
        }
        
        let r = minCenter - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
        lastCenterP = minIndex
        print(minIndex)
        return r
    }
    
    func centerForItem(at indexPath: IndexPath) -> CGPoint {
        let centers = [layoutP1.centerOf(indexPath), layoutP2.centerOf(indexPath), layoutP3.centerOf(indexPath)]
        return centers[0] * baryCentrics[0] + centers[1] * baryCentrics[1] + centers[2] * baryCentrics[2]
    }

    func frameForItem(at indexPath: IndexPath) -> CGRect {
        let frames = [layoutP1.frameOf(indexPath), layoutP2.frameOf(indexPath), layoutP3.frameOf(indexPath)]
        return frames[0] * baryCentrics[0] + frames[1] * baryCentrics[1] + frames[2] * baryCentrics[2]
    }
    
    private var maxRow: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    private var maxCol: Int {
        return collectionView!.numberOfSections
    }
}


