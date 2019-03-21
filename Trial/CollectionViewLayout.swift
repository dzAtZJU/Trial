//
//  CollectionViewLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/12.
//  Copyright © 2019 周巍然. All rights reserved.
//
import UIKit
import CoreGraphics

let rowGap0:CGFloat = 30
let rowGap1:CGFloat = 25
let rowGapN:CGFloat = 20

let colGap0:CGFloat = 15
let colGap1:CGFloat = 20
let colGapN:CGFloat = 15

struct Center {
    let row: Int
    let col: Int
    let timing: CGFloat
    let priority: Int // 0 1 2
}

class CollectionViewLayout: UICollectionViewLayout {
    
    private var centers = [Center]()
    func updateCentersWhen(viewCenter: CGPoint) {
        var distanceForEachItem = [IndexPath:CGFloat]()
        for cell in collectionView!.visibleCells {
            let indexPath = collectionView!.indexPath(for: cell)!
            let row = indexPath.section
            let col = indexPath.row
            let y = yForEachRow[row]!
            let x = xForEachCol[col]!
            let distance = hypot(y - viewCenter.y, x - viewCenter.x)
            distanceForEachItem[indexPath] = distance
        }
        let min = distanceForEachItem.min {
            $0.value < $1.value
        }!
        centers.append(Center(row: min.key.section, col: min.key.row, timing: timingFrom(distance: distance), priority: 0))
        
        distanceForEachItem[min.key] = CGFloat(Int.max)
        let min1 = distanceForEachItem.min {
            $0.value < $1.value
            }!
        centers.append(Center(row: min1.key.section, col: min1.key.row, timing: timingFrom(distance: distance), priority: 1))
    }
    func timingFrom(distance: CGFloat) -> CGFloat {
        return 1 - min(1, distance / CGFloat(self.itemHeight))
    }
    
    override func prepare() {
        updateDistances()
        updateXs()
        updateYs()
    }
    
    // 1.
    private var distanceOfEachItem = [IndexPath:CGFloat]()
    
    // 2.
    func sizeOfItem(_ indexPath: IndexPath) -> CGSize {
        let distance = distanceOfEachItem[indexPath]!
        let scale = scaleFromTiming(timingFrom(distance: distance))
        let width = CGFloat(self.itemWidth) * scale
        let height = CGFloat(self.itemHeight) * scale
        return CGSize(width: width, height: height)
    }
    
    // 3.
//    func 
    
    // 4.
    var xForEachCol = [Int : CGFloat]()
    func updateXs() {
        func updateXForCol(_ col: Int) {
            xForEachCol[col] = xForEachCol[col - 1]! + colGapBefore(col: col)
        }
        
        for col in 0..<collectionView!.numberOfItems(inSection: 0) {
            updateXForCol(col)
        }
    }
    
    
    var viewCenter: CGPoint = CGPoint.zero

    func updateDistances() {
        for row in 0..<collectionView!.numberOfSections {
            for col in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(row: col, section: row)
                let center = centerOf(item: indexPath)
                distanceOfEachItem[indexPath] = hypot(center.x - viewCenter.x, center.y - viewCenter.y)
            }
        }
    }
    
    func centerOf(item: IndexPath) -> CGPoint {
        return .zero
    }
    
    func scaleFromTiming(_ timing: CGFloat) -> CGFloat {
        return CGFloat(1 + timing / 5)
    }
    
    func valueFromTiming(_ timing: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat {
        return start + (end - start) * timing
    }
    
    func colGapFromTiming(_ timing: CGFloat) -> CGFloat {
        return colGap1 + (colGap0 - colGap1) * timing
    }
    
    func timingForCol(_ col:Int) -> CGFloat {
        return centers.first {
            $0.col == col
            }?.timing ?? 1
    }
    func colGapBefore(col: Int) -> CGFloat {
        let matchedCenters = centers.filter {
            ($0.col == col || $0.col == (col - 1))
        }
        if let priority0Center = matchedCenters.first(where: { $0.priority == 0 }) {
            return valueFromTiming(priority0Center.timing, start: colGap1, end: colGap0)
        } else if let priority1Center = matchedCenters.first(where: { $0.priority == 1}) {
            return valueFromTiming(priority1Center.timing, start: colGapN, end: colGap1)
        } else {
            return colGapN
        }
    }
    
    var yForEachRow = [Int : CGFloat]()
    func updateYs() {
        func updateYForRow(_ row: Int) {
            yForEachRow[row] = yForEachRow[row - 1]! + CGFloat(self.itemHeight) * scaleFromTiming(timingForRow(row)) + rowGapBefore(row: row)
        }
        
        for row in 0..<collectionView!.numberOfSections {
            updateYForRow(row)
        }
    }
    func timingForRow(_ row:Int) -> CGFloat {
        return centers.first {
            $0.row == row
            }?.timing ?? 1
    }
    func rowGapBefore(row: Int) -> CGFloat {
        let matchedCenters = centers.filter {
            ($0.row == row || $0.row == (row - 1))
        }
        if let priority0Center = matchedCenters.first(where: { $0.priority == 0 }) {
            return valueFromTiming(priority0Center.timing, start: rowGap1, end: rowGap0)
        } else if let priority1Center = matchedCenters.first(where: { $0.priority == 1}) {
            return valueFromTiming(priority1Center.timing, start: rowGapN, end: rowGap1)
        } else {
            return rowGapN
        }
    }
    
    
    
//    func distanceFromCenterTo(_ indexPath: IndexPath) -> CGFloat {
//        // indexPath
//    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = LayoutAttributes(forCellWith: indexPath)
        
        let (originX, originY) = originForItem(col: indexPath.row, row: indexPath.section)
        attributes.frame = CGRect(x: originX, y: originY, width: itemWidth, height: itemHeight)
        attributes.alpha = defaultAlpha
        
        if indexPath == centerItem {
            let timing = 1 - distance
            let scale = scaleFromTiming(timing)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            attributes.alpha = alphaFromTiming(timing)
            attributes.timing = timing
        }
        
        return attributes
    }
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = LayoutAttributes(forCellWith: indexPath)
//
//        let (originX, originY) = originForItem(col: indexPath.row, row: indexPath.section)
//        attributes.frame = CGRect(x: originX, y: originY, width: itemWidth, height: itemHeight)
//        attributes.alpha = defaultAlpha
//
//        if indexPath == centerItem {
//            let timing = 1 - distance
//            let scale = scaleFromTiming(timing)
//            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
//            attributes.alpha = alphaFromTiming(timing)
//            attributes.timing = timing
//        }
//
//        return attributes
//    }
    
    init(itemWidth: Int, itemHeight: Int) {
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        itemWidth = 315
        itemHeight = 180
        super.init(coder: aDecoder)
    }
    
    static func scene1() -> CollectionViewLayout {
        return CollectionViewLayout(itemWidth: 315, itemHeight: 180)
    }
    
    static func scene1To2(scale: Float) -> CollectionViewLayout {
        return CollectionViewLayout(itemWidth: Int(375 * scale), itemHeight: Int(225 * scale))
    }
    
    static func scene2() -> CollectionViewLayout {
        return CollectionViewLayout(itemWidth: 375, itemHeight: 225)
    }
    
    let itemWidth: Int
    let itemHeight: Int
    
    var rowGap: Int {
        return itemHeight / 8
    }
    
    var colGap: Int {
        return rowGap
    }
    
    var leftGap: Int {
        return rowGap * 5 / 3
    }
    
    var topGap: Int {
        return leftGap
    }
    
    var maxDistance: Float {
        return hypotf(Float(itemHeight), Float(itemWidth)) / 2
    }
    
    var itemWidthPlusGap: Int {
        return itemWidth + colGap
    }
    
    var itemHeightPlusGap: Int {
        return itemHeight + rowGap
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        if let centerItem = centerItem {
//            var nextItem = centerItem
//            if hypot(velocity.x, velocity.y) > velocityThreshold {
//                let direction = Direction.fromVelocity(velocity)
//                nextItem = nextItemOnDirection(direction, currentItem: centerItem)
//            }
//            let frame = frameIncludingGapsForItem(col: nextItem.row, row: nextItem.section)
//            print("\(centerItem)")
//            return CGPoint(x: frame.midX - collectionView!.bounds.width / 2, y: frame.midY - collectionView!.bounds.height / 2)
//        }
//
//        return proposedContentOffset
//    }
    
    func nextItemOnDirection(_ direction: Direction) -> IndexPath {
        
        let currentRow = centerItem!.section
        let currentCol = centerItem!.row
        let maxRow = collectionView!.numberOfSections
        let maxCol = collectionView!.numberOfItems(inSection: 0)
        var nextRow: Int
        var nextCol: Int
        switch direction {
        case .N:
            (nextRow, nextCol) = boundedElement(row: currentRow + 1, col: currentCol, maxRow: maxRow, maxCol: maxCol)
        case .EN:
            (nextRow, nextCol) = boundedElement(row: currentRow + 1, col: currentCol + 1, maxRow: maxRow, maxCol: maxCol)
        case .E:
            (nextRow, nextCol) = boundedElement(row: currentRow, col: currentCol + 1, maxRow: maxRow, maxCol: maxCol)
        case .ES:
            (nextRow, nextCol) = boundedElement(row: currentRow - 1, col: currentCol + 1, maxRow: maxRow, maxCol: maxCol)
        case .S:
            (nextRow, nextCol) = boundedElement(row: currentRow - 1, col: currentCol, maxRow: maxRow, maxCol: maxCol)
        case .WS:
            (nextRow, nextCol) = boundedElement(row: currentRow - 1, col: currentCol + 1, maxRow: maxRow, maxCol: maxCol)
        case .W:
            (nextRow, nextCol) = boundedElement(row: currentRow, col: currentCol - 1, maxRow: maxRow, maxCol: maxCol)
        case .WN:
            (nextRow, nextCol) = boundedElement(row: currentRow + 1, col: currentCol - 1, maxRow: maxRow, maxCol: maxCol)
        }
        return IndexPath(row: nextCol, section: nextRow)
    }
    
    var centerItem: IndexPath?
    var distance: CGFloat = 1
    func updateCenter(_ center: CGPoint) {
        self.centerItem = gappedItemContains(point: center)
        distance = normalizedDistanceBetween(item: self.centerItem!, point: center)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        let width = collectionView!.numberOfItems(inSection: 0) * itemWidthPlusGap - colGap + 2 * leftGap
        let height = collectionView!.numberOfSections * itemHeightPlusGap - rowGap + 2 * topGap
        return CGSize(width: width, height: height)
    }
    
    func alphaFromTiming(_ timing: CGFloat) -> CGFloat {
        return CGFloat(timing / 2 + defaultAlpha)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var result = [UICollectionViewLayoutAttributes]()
        for section in 0..<collectionView!.numberOfSections {
            for row in 0..<collectionView!.numberOfItems(inSection: section) {
                if let attribute = layoutAttributesForItem(at: IndexPath(row: row, section: section)), attribute.frame.intersects(rect) {
                    result.append(attribute)
                }
            }
        }
        return result
    }
    
    func gappedItemContains(point: CGPoint) -> IndexPath {
        for section in 0..<collectionView!.numberOfSections {
            for row in 0..<collectionView!.numberOfItems(inSection: section) {
                let frame = frameIncludingGapsForItem(col: row, row: section)
                if frame.contains(point) {
                    return IndexPath(row: row, section: section)
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func frameIncludingGapsForItem(col: Int, row: Int) -> CGRect {
        let origin = originForItem(col: col, row: row)
        return CGRect(x: origin.0 - colGap / 2, y: origin.1 - rowGap / 2, width: itemWidth + colGap, height: itemHeight + rowGap)
    }
    
    func originForItem(col: Int, row: Int) -> (Int, Int) {
        return (leftGap + col * itemWidthPlusGap, topGap + row * itemHeightPlusGap)
    }
    
    func normalizedDistanceBetween(item: IndexPath, point: CGPoint) -> CGFloat {
        let frame = frameIncludingGapsForItem(col: item.row, row: item.section)
        return normalizedDistanceToCenterOf(rec: frame, endPoint: point)
    }
}
