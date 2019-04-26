//
//  RippleLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/21.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class Template: NSObject {
    static let watch = Template(uiTemplates: UITemplates.watch)
    
    static let surf = Template(uiTemplates: UITemplates.surf)
    
    static let watchLand = Template(uiTemplates: UITemplates.watchLand)
    
    static let surfLand = Template(uiTemplates: UITemplates.surfLand)
    
    func nextOnScene() -> Template {
        switch self {
        case .watch:
            return .surf
        case .surf:
            return .watch
        case .watchLand:
            return .surfLand
        case .surfLand:
            return .watchLand
        default:
            fatalError("")
        }
    }
    
    func nextOnRotate() -> Template {
        switch self {
        case .watch:
            return .watchLand
        case .surf:
            return .surfLand
        case .watchLand:
            return .watch
        case .surfLand:
            return .surf
        default:
            fatalError("")
        }
    }
    
    func onFull() -> Template {
        uiTemplates = uiTemplates.fulled()
        return self
    }
    
    func backFromFull() -> Template {
        uiTemplates = uiTemplates.backFromFulled()
        return self
    }
    
    var uiTemplates: UITemplates
    
    init(uiTemplates: UITemplates) {
        self.uiTemplates = uiTemplates
    }
    
    func center() -> CGPoint {
        return CGPoint(x: uiTemplates.itemWidth * CGFloat(initialCenter1.section + 2), y: uiTemplates.itemHeight * CGFloat(initialCenter1.row + 2))
    }
    
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
        
        let gap = gapAround(dRow: dRow, dCol: dCol - 1, values: uiTemplates.colGaps)
        let dX = dXOf(dCol: Int(dCol - 1), dRow: Int(dRow)) + magnitudeOf(dCol - 1, value: uiTemplates.itemWidth) / 2 + gap + magnitudeOf(dCol, value: uiTemplates.itemWidth) / 2
        
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
        
        let dY = dYOf(Int(dRow - 1)) + magnitudeOf(dRow - 1, value: uiTemplates.itemHeight) / 2 + gapAround(dRow - 1, values: uiTemplates.rowGaps) + magnitudeOf(dRow, value: uiTemplates.itemHeight) / 2
        dRow2dY[dRow] = dY
        return sign * dY
    }
    
    func magnitudeOf(_ d: CGFloat, value: CGFloat) -> CGFloat {
        if d == 0 {
            return value * uiTemplates.scale
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
            return CGSize(width: uiTemplates.itemWidth * uiTemplates.scale, height: uiTemplates.itemHeight * uiTemplates.scale)
        }
        
        return CGSize(width: uiTemplates.itemWidth, height: uiTemplates.itemHeight)
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
    
    func nextLayoutOn(direction: Direction) -> RippleLayout {
        let nextItem = nextItemOn(direction: direction, currentItem: center, maxRow: collectionView!.numberOfItems(inSection: 0) , maxCol: collectionView!.numberOfSections)
        let nextPosition = centerOf(nextItem)
        return RippleLayout(theCenter: nextItem, theCenterPosition: nextPosition, theTemplate: template)
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
