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
    var vertex2Layout: [IndexPath: (CGFloat, RippleLayout)]
    
    var centerItem: IndexPath {
        let (key, _) = self.vertex2Layout.max { (l1, l2) -> Bool in
            return l1.value.0 < l2.value.0
        }!
        
        return key
    }
    
    private var triangle: [IndexPath] {
        return Array(vertex2Layout.keys)
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
        self.lastCenterP = layoutP1.center
        self.uiTemplates = uiTemplates
        
        self.vertex2Layout = [IndexPath: (CGFloat, RippleLayout)]()
        self.vertex2Layout[layoutP1.center] = (1, layoutP1)
        self.vertex2Layout[layoutP2.center] = (0, layoutP2)
        self.vertex2Layout[layoutP3.center] = (0, layoutP3)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // 中心的 item
    @objc var lastCenterP: IndexPath
    
    func viewPortCenterChanged() {
        if let (newCenterTriangle, newbary) = reComputeCenterTriangle() {
            if Set(Array(self.vertex2Layout.keys)) != Set(Array(newCenterTriangle.map{IndexPath($0)})) {
                updateCenterTriangle(newCenterTriangle, bary: newbary)
            } else {
                self.vertex2Layout[IndexPath(newCenterTriangle[0])]!.0 = newbary[0]
                self.vertex2Layout[IndexPath(newCenterTriangle[1])]!.0 = newbary[1]
                self.vertex2Layout[IndexPath(newCenterTriangle[2])]!.0 = newbary[2]
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let result = LayoutAttributes(forCellWith: indexPath)
        
        result.frame = frameForItem(at: indexPath)
        result.timing = timingForItem(at: indexPath)
        
        result.titleFontSize = uiTemplates.titleFontSize
        result.subtitleFontSize = uiTemplates.subtitleFontSize
        result.titlesBottom = uiTemplates.titlesBottom
        result.radius = uiTemplates.radius
        result.sceneState = rippleViewStore.state.scene
        result.zIndex = centerItem == indexPath ? 1 : 0
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
    
    func isViewCenterIn(indexTriangle: [CGPoint]) -> [CGFloat]? {
        let triangle = (centerForItem(at: IndexPath(indexTriangle[0])), centerForItem(at: IndexPath(indexTriangle[1])), centerForItem(at: IndexPath(indexTriangle[2])))
        let newBarycentric = barycentricOf(collectionView!.viewPortCenter, P1: triangle.0, P2: triangle.1, P3: triangle.2)
        let threshold: CGFloat = rippleViewStore.state.scene == .watching ? -0.02 : 0 // To soften Numeric effect
        if newBarycentric.allSatisfy({ $0 >= threshold }) {
            return newBarycentric
        }
        
        return nil
    }
    
    private func reComputeCenterTriangle() -> ([CGPoint], [CGFloat])? {
        var nextCenterTriangle: [CGPoint]?
        
        for indexTriangle in eightTrianglesAround(triangle) {
            if let newBarycentric = isViewCenterIn(indexTriangle: indexTriangle) {
                nextCenterTriangle = indexTriangle
                return (nextCenterTriangle!, newBarycentric)
            }
        }
        
        var nextbaryCentrics = [CGFloat]()
        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
            (row, col, stop) in
            for indexTriangle in indexTrianglesAround(CGPoint(x: row, y: col), maxRow: ytRows, maxCol: ytCols) {
                if let newBarycentric = isViewCenterIn(indexTriangle: indexTriangle) {
                    nextCenterTriangle = indexTriangle
                    nextbaryCentrics = newBarycentric
                    stop = true
                    break
                }
            }
        }
        
        if nextCenterTriangle != nil {
            return (nextCenterTriangle!, nextbaryCentrics)
        }
        
        return nil
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if !shouldPagedMove {
            return proposedContentOffset
        }
        
        let proposedCenter = proposedContentOffset + CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
        var minDistance = CGFloat(Int.max)
        var minCenter = CGPoint.zero
        var minIndex = lastCenterP
        let candidates = nearestFiveTo(lastCenterP, maxRow: ytRows, maxCol: ytCols) + fourDiagonalNeighborsOf(lastCenterP, maxRow: ytRows, maxCol: ytCols)
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
        return r
    }
    
    func centerForItem(at indexPath: IndexPath) -> CGPoint {
        var center = CGPoint.zero
        for (weight, layout) in self.vertex2Layout.values {
            center = center + layout.centerOf(indexPath) * weight
        }
        
        return center
    }

    func frameForItem(at indexPath: IndexPath) -> CGRect {
        var frame = CGRect.zero
        for (weight, layout) in self.vertex2Layout.values {
            frame = frame + layout.frameOf(indexPath) * weight
        }
        
        return frame
    }
    
    func timingForItem(at indexPath: IndexPath) -> CGFloat {
        var timing: CGFloat = 0
        for (weight, layout) in self.vertex2Layout.values {
            timing = timing + layout.timingOf(indexPath) * weight
        }
        
        return timing
    }
    
    private var maxRow: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    private var maxCol: Int {
        return collectionView!.numberOfSections
    }
}


