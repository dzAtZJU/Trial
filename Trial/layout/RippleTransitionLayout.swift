//
//  RippleTransitionLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit


let initialCenterTriangle = (CGPoint(x: 2, y: 2), CGPoint(x: 2, y: 1), CGPoint(x: 3, y: 2))

let initialCenter1 = IndexPath(row: 2, section: 2)
let initialPosition1 = CGPoint(x: Template.default2.dXOf(dCol: initialCenter1.section, dRow: initialCenter1.row) + 200, y: Template.default2.dYOf(initialCenter1.section) + 200)
let initialLayout1 = RippleLayout(theCenter: initialCenter1, theCenterPosition: initialPosition1)

let initialCenter2 = IndexPath(row: 1, section: 2)
let initialPosition2 = initialLayout1.centerOf(initialCenter2)
let initialLayout2 = RippleLayout(theCenter: initialCenter2, theCenterPosition: initialPosition2)

let initialCenter3 = IndexPath(row: 2, section: 3)
let initialPosition3 = initialLayout1.centerOf(initialCenter3)
let initialLayout3 = RippleLayout(theCenter: initialCenter3, theCenterPosition: initialPosition3)



class RippleTransitionLayout: UICollectionViewLayout {
    
    var layoutP1 = initialLayout1
    var layoutP2 = initialLayout2
    var layoutP3 = initialLayout3
    var viewCenter = initialPosition1
    var centerTriangle = initialCenterTriangle
    
    func viewCenterChanged(_ newViewCenter: CGPoint) {
        viewCenter = newViewCenter
        if let newCenterTriangle = reComputeCenterTriangle() {
            if newCenterTriangle != centerTriangle {
                updateCenterTriangle(newCenterTriangle)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let c123 = barycentricOf(viewCenter, P1: layoutP1.centerPosition, P2: layoutP2.centerPosition, P3: layoutP3.centerPosition)
        let attributes123 = [layoutP1.layoutAttributesForItem(at: indexPath)!, layoutP2.layoutAttributesForItem(at: indexPath)!, layoutP3.layoutAttributesForItem(at: indexPath)!]
     
        let result = LayoutAttributes(forCellWith: indexPath)
        result.frame = attributes123[0].frame * c123[0] + attributes123[1].frame * c123[1] + attributes123[2].frame * c123[2]
        result.timing = attributes123[0].timing * c123[0] + attributes123[1].timing * c123[1] + attributes123[2].timing * c123[2]
        
        
        return result
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var r =  [UICollectionViewLayoutAttributes]()
        doIn2DRange(maxRow: maxRow, maxCol: maxCol) {
            (row, col) in
            let a = layoutAttributesForItem(at: IndexPath(row: row, section: col))
            if a?.frame.intersects(rect) == true {
                r.append(a!)
            }
        }
        return r
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 1500, height: 1800)
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
            (row, col) in
            for indexTriangle in indexTrianglesAround(CGPoint(x: row, y: col)) {
                let triangle = (centerOf(item: indexTriangle.0), centerOf(item: indexTriangle.1), centerOf(item: indexTriangle.2))
                if isPointInTriangle(triangle, point: viewCenter) {
                    centerTriangle = indexTriangle
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
        layoutP1 = RippleLayout(theCenter: center1, theCenterPosition: layoutP1.centerOf(center1))
        
        let center2 = IndexPath(row: Int(P2.y), section: Int(P2.x))
        layoutP2 = RippleLayout(theCenter: center2, theCenterPosition: layoutP1.centerOf(center2))
        
        let center3 = IndexPath(row: Int(P3.y), section: Int(P3.x))
        layoutP3 = RippleLayout(theCenter: center3, theCenterPosition: layoutP1.centerOf(center3))
    }
    
    private var maxRow: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    private var maxCol: Int {
        return collectionView!.numberOfSections
    }
}


