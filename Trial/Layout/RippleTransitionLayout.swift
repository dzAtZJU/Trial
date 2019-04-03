////
////  RippleTransitionLayout.swift
////  Trial
////
////  Created by 周巍然 on 2019/3/22.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//let initialCenterTriangle = (CGPoint(x: 2, y: 2), CGPoint(x: 2, y: 1), CGPoint(x: 3, y: 2))
//
//let initialCenter1 = IndexPath(row: 2, section: 2)
//let initialPosition1 = CGPoint(x: Template.watch.dXOf(dCol: initialCenter1.section, dRow: initialCenter1.row) + 200, y: Template.watch.dYOf(initialCenter1.section) + 200)
//let initialLayout1 = RippleLayout(theCenter: initialCenter1, theCenterPosition: initialPosition1, theTemplate: Template.watch)
//
//let initialCenter2 = IndexPath(row: 1, section: 2)
//let initialPosition2 = initialLayout1.centerOf(initialCenter2)
//let initialLayout2 = RippleLayout(theCenter: initialCenter2, theCenterPosition: initialPosition2, theTemplate: Template.watch)
//
//let initialCenter3 = IndexPath(row: 2, section: 3)
//let initialPosition3 = initialLayout1.centerOf(initialCenter3)
//let initialLayout3 = RippleLayout(theCenter: initialCenter3, theCenterPosition: initialPosition3, theTemplate: Template.watch)
//
//let initialCenter1ForSurf = IndexPath(row: 2, section: 2)
//let initialPosition1ForSurf = CGPoint(x: Template.surf.dXOf(dCol: initialCenter1.section, dRow: initialCenter1.row) + 200, y: Template.surf.dYOf(initialCenter1.section) + 200)
//let initialLayout1ForSurf = RippleLayout(theCenter: initialCenter1ForSurf, theCenterPosition: initialPosition1ForSurf, theTemplate: Template.surf)
//
//
//class RippleTransitionLayout: UICollectionViewLayout {
//
//    var layoutP1: RippleLayout
//    var layoutP2: RippleLayout
//    var layoutP3: RippleLayout
//
//    var viewCenter: CGPoint
//    var centerTriangle: (CGPoint, CGPoint, CGPoint)
//    var baryCentrics = [CGFloat].init(repeating: 0, count: 3)
//
//    // 中心的 item
//    @objc var lastCenterP: IndexPath
//
//    init(viewCenter: CGPoint, layoutP1: RippleLayout, layoutP2: RippleLayout, layoutP3: RippleLayout) {
//        self.viewCenter = viewCenter
//        self.layoutP1 = layoutP1
//        self.layoutP2 = layoutP2
//        self.layoutP3 = layoutP3
//        self.centerTriangle = (CGPoint(layoutP1.center), CGPoint(layoutP2.center), CGPoint(layoutP3.center))
//        self.lastCenterP = layoutP1.center
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        self.viewCenter = initialPosition1
//        self.layoutP1 = initialLayout1
//        self.layoutP2 = initialLayout2
//        self.layoutP3 = initialLayout3
//        self.centerTriangle = (CGPoint(layoutP1.center), CGPoint(layoutP2.center), CGPoint(layoutP3.center))
//        self.lastCenterP = layoutP1.center
//        super.init(coder: aDecoder)
//    }
//
//    func viewCenterChanged(_ newViewCenter: CGPoint) {
//        viewCenter = newViewCenter
//        if let newCenterTriangle = reComputeCenterTriangle() {
//            if newCenterTriangle != centerTriangle {
//                updateCenterTriangle(newCenterTriangle)
//            }
//        }
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let c123 = barycentricOf(viewCenter, P1: layoutP1.centerPosition, P2: layoutP2.centerPosition, P3: layoutP3.centerPosition)
//        let attributes123 = [layoutP1.layoutAttributesForItem(at: indexPath)!, layoutP2.layoutAttributesForItem(at: indexPath)!, layoutP3.layoutAttributesForItem(at: indexPath)!]
//
//        let result = LayoutAttributes(forCellWith: indexPath)
//        result.frame = attributes123[0].frame * c123[0] + attributes123[1].frame * c123[1] + attributes123[2].frame * c123[2]
//        result.timing = attributes123[0].timing * c123[0] + attributes123[1].timing * c123[1] + attributes123[2].timing * c123[2]
//
//
//        return result
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var r =  [UICollectionViewLayoutAttributes]()
//        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
//            (row, col) in
//            let a = layoutAttributesForItem(at: IndexPath(row: row, section: col))
//            if a?.frame.intersects(rect) == true {
//                r.append(a!)
//            }
//        }
//        return r
//    }
//
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: CGFloat(2 + ytCols) * layoutP1.template.width, height: CGFloat(3 + ytRows) * layoutP1.template.height)
//    }
//
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
//
//    func centerOf(item: CGPoint) -> CGPoint {
//        let index = IndexPath(row: Int(item.y), section: Int(item.x))
//        let frame = layoutAttributesForItem(at: index)!.frame
//        return CGPoint(x: frame.midX, y: frame.midY)
//    }
//
//    var centerItem: IndexPath {
//        let position = indexOfMax(baryCentrics)
//        if position == 0 {
//            return IndexPath(centerTriangle.0)
//        } else if position == 1 {
//            return IndexPath(centerTriangle.1)
//        } else {
//            return IndexPath(centerTriangle.2)
//        }
//    }
//
//    private func reComputeCenterTriangle() -> (CGPoint, CGPoint, CGPoint)?{
//        var centerTriangle: (CGPoint, CGPoint, CGPoint)?
//        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
//            (row, col) in
//            for indexTriangle in indexTrianglesAround(CGPoint(x: row, y: col)) {
//                let triangle = (centerOf(item: indexTriangle.0), centerOf(item: indexTriangle.1), centerOf(item: indexTriangle.2))
//                let theBarycentric = barycentricOf(viewCenter, P1: triangle.0, P2: triangle.1, P3: triangle.2)
//                if theBarycentric.allSatisfy({ $0 > 0 }) {
//                    centerTriangle = indexTriangle
//                    baryCentrics = theBarycentric
//                    break
//                }
//            }
//        }
//        return centerTriangle
//    }
//
//    private func updateCenterTriangle(_ new: (CGPoint, CGPoint, CGPoint)) {
//        centerTriangle = new
//        let P1 = centerTriangle.0, P2 = centerTriangle.1, P3 = centerTriangle.2
//
//        let center1 = IndexPath(row: Int(P1.y), section: Int(P1.x))
//        layoutP1 = RippleLayout(theCenter: center1, theCenterPosition: layoutP1.centerOf(center1), theTemplate: layoutP1.template)
//
//        let center2 = IndexPath(row: Int(P2.y), section: Int(P2.x))
//        layoutP2 = RippleLayout(theCenter: center2, theCenterPosition: layoutP1.centerOf(center2), theTemplate: layoutP1.template)
//
//        let center3 = IndexPath(row: Int(P3.y), section: Int(P3.x))
//        layoutP3 = RippleLayout(theCenter: center3, theCenterPosition: layoutP1.centerOf(center3), theTemplate: layoutP1.template)
//
//    }
//
//    static func from(template: Template, center1: IndexPath, position: CGPoint, center2: IndexPath, center3: IndexPath) -> RippleTransitionLayout {
//        let layoutP1 = RippleLayout(theCenter: center1, theCenterPosition: position, theTemplate: template)
//        let layoutP2 = RippleLayout(theCenter: center2, theCenterPosition: layoutP1.centerOf(center2), theTemplate: template)
//        let layoutP3 = RippleLayout(theCenter: center3, theCenterPosition: layoutP1.centerOf(center3), theTemplate: template)
//
//
//        return RippleTransitionLayout(viewCenter: position, layoutP1: layoutP1, layoutP2: layoutP2, layoutP3: layoutP3)
//    }
//
//    static func nextLayoutForSurf(center: IndexPath, centerPosition: CGPoint) -> RippleTransitionLayout {
//        let triangle = defaultIndexTriangleAround(center)
//        return from(template: Template.surf, center1: triangle.0, position: centerPosition, center2: triangle.1, center3: triangle.2)
//    }
//
//    static func initialLayoutForWatch(centerLayout: RippleLayout) -> RippleTransitionLayout {
//        let triangle = defaultIndexTriangleAround(centerLayout.center)
//        return from(template: Template.watch, center1: triangle.0, position: Template.watch.center(), center2: triangle.1, center3: triangle.2)
//    }
//
//    static func nextLayoutForWatch(center: IndexPath, centerPosition: CGPoint) -> RippleTransitionLayout {
//        let triangle = defaultIndexTriangleAround(center)
//        return from(template: Template.watch, center1: triangle.0, position: centerPosition, center2: triangle.1, center3: triangle.2)
//    }
//
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        let proposedCenter = proposedContentOffset + CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
//        var minDistance = CGFloat(Int.max)
//        var minCenter = CGPoint.zero
//        var minIndex = lastCenterP
//        for indexPath in nearestFiveTo(lastCenterP, maxRow: ytRows, maxCol: ytCols) {
//            let center = centerOf(item: CGPoint(indexPath))
//            let distance = distanceBetween(left: center, right: proposedCenter)
//            if distance < minDistance {
//                minDistance = distance
//                minCenter = center
//                minIndex = indexPath
//            }
//        }
//        let r = minCenter - CGPoint(x: collectionView!.frame.width / 2, y: collectionView!.frame.height / 2)
//        setValue(minIndex, forKey: "lastCenterP")
////        lastCenterP = minIndex
//        return r
//    }
//
//    private var maxRow: Int {
//        return collectionView!.numberOfItems(inSection: 0)
//    }
//
//    private var maxCol: Int {
//        return collectionView!.numberOfSections
//    }
//}
//
//
