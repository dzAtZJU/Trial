//
//  RippleLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/21.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

let scale: CGFloat = 1.2

let itemHeight: CGFloat = 100
let rowGaps: [CGFloat] = [30, 25, 20]

let itemWidth: CGFloat = 150
let colGaps: [[CGFloat]] = [[25, 20], [20, 20], [15, 15]]

class Template {
    
    static let default2 = Template()
    
    var dColRow2dX = [IndexPath: CGFloat]()
    var dRow2dY = [CGFloat: CGFloat]()

    func dXOf(dCol: Int, dRow: Int) -> CGFloat {
        if dCol == 0 {
            return 0
        }
        let sign = CGFloat(dCol.signum())
        
        let dCol = CGFloat(abs(dCol))
        let dRow = CGFloat(abs(dRow))
        if let dX = dColRow2dX[IndexPath(row: Int(dRow), section: Int(dCol))] {
            return sign * dX
        }
        
        let gap = gapAround(dRow: dRow, dCol: dCol - 1, values: colGaps)
        let dX = dXOf(dCol: Int(dCol - 1), dRow: Int(dRow)) + magnitudeOf(dCol - 1, value: itemWidth) / 2 + gap + magnitudeOf(dCol, value: itemWidth) / 2
        
        return sign * dX
    }
    
    func dYOf(_ dRow: Int) -> CGFloat {
        if dRow == 0 {
            return 0
        }
        let sign = CGFloat(dRow.signum())
        
        let dRow = CGFloat(abs(dRow))
        if let dY = dRow2dY[dRow] {
            return sign * dY
        }
        
        let dY = dYOf(Int(dRow - 1)) + magnitudeOf(dRow - 1, value: itemHeight) / 2 + gapAround(dRow - 1, values: rowGaps) + magnitudeOf(dRow, value: itemHeight) / 2
        dRow2dY[dRow] = dY
        return sign * dY
    }
    
    func magnitudeOf(_ d: CGFloat, value: CGFloat) -> CGFloat {
        if d == 0 {
            return value * scale
        }
        
        return value
    }
    
    func gapAround(dRow: CGFloat, dCol: CGFloat, values: [[CGFloat]]) -> CGFloat {
        let a = min(Int(dRow), values.count - 1)
        return values[a][min(Int(dCol), values[a].count - 1)]
    }
    
    func gapAround(_ d: CGFloat, values: [CGFloat]) -> CGFloat {
        let d = min(abs(Int(d)), values.count - 1)
        return values[d]
    }
    
    func sizeOfItem(dRow: Int, dCol: Int) -> CGSize {
        if dRow == 0 && dCol == 0 {
            return CGSize(width: itemWidth * scale, height: itemHeight * scale)
        }
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}


class RippleLayout: UICollectionViewLayout {
    
    let center: IndexPath
    let centerPosition: CGPoint
    
    init(theCenter: IndexPath, theCenterPosition: CGPoint) {
        center = theCenter
        centerPosition = theCenterPosition
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        center = initialItem
        centerPosition = initialPosition
        super.init(coder: aDecoder)
    }
    
    func dColRowOf(_ indexPath: IndexPath) -> (Int, Int) {
        return (indexPath.section - center.section, indexPath.row - center.row)
    }
        
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let (dCol, dRow) = dColRowOf(indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.bounds = CGRect(origin: .zero, size: Template.default2.sizeOfItem(dRow: dRow, dCol: dCol))
        attributes.center = CGPoint(x: Template.default2.dXOf(dCol: dCol, dRow: dRow) + centerPosition.x, y: Template.default2.dYOf(dRow) + centerPosition.y)
        print("row:\(dRow) col:\(dCol)  x:\(attributes.center.x) y:\(attributes.center.y)")
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var r =  [UICollectionViewLayoutAttributes]()
        for section in 0..<collectionView!.numberOfSections {
            for row in 0..<collectionView!.numberOfItems(inSection: section) {
                let a = layoutAttributesForItem(at: IndexPath(row: row, section: section))
                if a?.frame.intersects(rect) == true {
                    r.append(a!)
                }
            }
        }
        return r
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 1500, height: 1800)
    }
}

struct CentralBlock {
    let current: IndexPath
    let next: IndexPath
    let distanceToCurrent: CGFloat
    let distanceToNext: CGFloat
    
    func sameBlockAs(_ block: CentralBlock) -> Bool {
        return current == block.current && next == block.next
    }
}

extension RippleLayout {
    
    func getCurrentAndNextCentralItem(viewCenter: CGPoint) -> CentralBlock {
        var distanceForEachItem = [IndexPath:CGFloat]()
        for cell in collectionView!.visibleCells {
            let indexPath = collectionView!.indexPath(for: cell)!
            let distance = hypot(cell.frame.midY - viewCenter.y, cell.frame.midX - viewCenter.x)
            distanceForEachItem[indexPath] = distance
        }
        
        
        let min = distanceForEachItem.min {
            $0.value < $1.value
            }!
        
        distanceForEachItem[min.key] = CGFloat(Int.max)
        let min1 = distanceForEachItem.min {
            $0.value < $1.value
            }!
        
        let centralBlock = CentralBlock(current: min.key, next: min1.key, distanceToCurrent: min.value, distanceToNext: min1.value)
        return centralBlock
    }
    
}
