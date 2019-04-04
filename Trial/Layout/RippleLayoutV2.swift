//
//  RippleLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/21.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

//let scale: CGFloat = 1.2
//
//let itemHeight: CGFloat = 100
//let rowGaps: [CGFloat] = [30, 25, 20]
//
//let itemWidth: CGFloat = 150
//let colGaps: [[CGFloat]] = [[25, 20], [20, 20], [15, 15]]
//
//let itemWidthForWatching = itemWidth * 1.8
//let itemHeightForWatching = itemHeight * 1.8

class Template {
    
    let width: CGFloat
    let height: CGFloat
    
    init(w: CGFloat, h: CGFloat) {
        width = w
        height = h
    }
    
    func center() -> CGPoint {
        return CGPoint(x: width * CGFloat(initialCenter1.section + 2), y: height * CGFloat(initialCenter1.row + 2))
    }
    
    static let watch = Template(w: itemWidthForWatching, h: itemHeightForWatching)
    static let surf = Template(w: itemWidth, h: itemHeight)
    
    func toggledTemplate() -> Template {
        return self === Template.watch ? Template.surf : Template.watch
    }
    
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
        let dX = dXOf(dCol: Int(dCol - 1), dRow: Int(dRow)) + magnitudeOf(dCol - 1, value: width) / 2 + gap + magnitudeOf(dCol, value: width) / 2
        
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
        
        let dY = dYOf(Int(dRow - 1)) + magnitudeOf(dRow - 1, value: height) / 2 + gapAround(dRow - 1, values: rowGaps) + magnitudeOf(dRow, value: height) / 2
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
            return CGSize(width: width * scale, height: height * scale)
        }
        
        return CGSize(width: width, height: height)
    }
    
}


class RippleLayout: UICollectionViewLayout {
    
    let center: IndexPath
    var centerPosition: CGPoint
    var template: Template
    
    init(theCenter: IndexPath, theCenterPosition: CGPoint, theTemplate: Template) {
        center = theCenter
        centerPosition = theCenterPosition
        template = theTemplate
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        center = initialCenter1
        centerPosition = initialPosition1
        template = Template.watch
        super.init(coder: aDecoder)
    }
    
    var viewPortCenter = IndexPath(row: 2, section: 2)
    
    func updateViewPortCenter(_ indexPath: IndexPath) {
        viewPortCenter = indexPath
    }
    
    func dColRowOf(_ indexPath: IndexPath) -> (Int, Int) {
        return (indexPath.section - center.section, indexPath.row - center.row)
    }
    
    func centerOf(_ indexPath: IndexPath) -> CGPoint {
        let (dCol, dRow) = dColRowOf(indexPath)
        return CGPoint(x: template.dXOf(dCol: dCol, dRow: dRow) + centerPosition.x, y: template.dYOf(dRow) + centerPosition.y)
    }
    
    func timingOf(_ indexPath: IndexPath) -> CGFloat {
        if indexPath == center {
            return 1
        }
        
        return 0
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> LayoutAttributes? {
        let (dCol, dRow) = dColRowOf(indexPath)
        let attributes = LayoutAttributes(forCellWith: indexPath)
        attributes.bounds = CGRect(origin: .zero, size: template.sizeOfItem(dRow: dRow, dCol: dCol))
        attributes.center = centerOf(indexPath)
        attributes.timing = timingOf(indexPath)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var r =  [UICollectionViewLayoutAttributes]()
        doIn2DRange(maxRow: ytRows, maxCol: ytCols) {
            (row, col, _) in
            let a = layoutAttributesForItem(at: IndexPath(row: row, section: col))
            if a?.frame.intersects(rect) == true {
                r.append(a!)
            }
        }
        return r
    }
    
    func nextLayoutOn(direction: Direction) -> RippleLayout {
        let nextItem = nextItemOn(direction: direction, currentItem: center, maxRow: collectionView!.numberOfItems(inSection: 0) , maxCol: collectionView!.numberOfSections)
        let nextPosition = centerOf(nextItem)
        return RippleLayout(theCenter: nextItem, theCenterPosition: nextPosition, theTemplate: template)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: template.width * CGFloat(ytCols + 1), height: template.width * CGFloat(ytRows + 1))
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let direction = collectionView!.transitionDirection {
            var offset: CGPoint?
            switch direction {
            case .N:
                offset = CGPoint(x: 0, y: -template.height - rowGapN)
            case .S:
                offset = CGPoint(x: 0, y: template.height + rowGapN)
            case .W:
                offset = CGPoint(x: -template.width - colGapN, y: 0)
            default:
                offset = CGPoint(x: template.width + colGapN, y: 0)
            }
            return proposedContentOffset + offset!
        }
        return proposedContentOffset
    }
    
    override var collectionView: RippleCollectionView? {
        return super.collectionView as? RippleCollectionView
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
//
//extension RippleLayout {
//
//    func getCurrentAndNextCentralItem(viewCenter: CGPoint) -> CentralBlock {
//        var distanceForEachItem = [IndexPath:CGFloat]()
//        for cell in collectionView!.visibleCells {
//            let indexPath = collectionView!.indexPath(for: cell)!
//            let distance = hypot(cell.frame.midY - viewCenter.y, cell.frame.midX - viewCenter.x)
//            distanceForEachItem[indexPath] = distance
//        }
//
//
//        let min = distanceForEachItem.min {
//            $0.value < $1.value
//            }!
//
//        distanceForEachItem[min.key] = CGFloat(Int.max)
//        let min1 = distanceForEachItem.min {
//            $0.value < $1.value
//            }!
//
//        let centralBlock = CentralBlock(current: min.key, next: min1.key, distanceToCurrent: min.value, distanceToNext: min1.value)
//        return centralBlock
//    }
//
//}
