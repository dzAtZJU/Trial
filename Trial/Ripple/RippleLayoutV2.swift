//
//  RippleLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/21.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class LayoutCalcuTemplate: NSObject {
    
    func nextOnScene() -> LayoutCalcuTemplate {
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
    
    func nextOnRotate() -> LayoutCalcuTemplate {
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
    
    // One path covering different states
    func nextOnFull() -> LayoutCalcuTemplate {
        switch self {
        case .watch, .watchLand:
            return .full
        case .full:
            return .watch
        default:
            fatalError()
        }
    }
    
    // Another path covring different states
    func nextOnStagedFull() -> LayoutCalcuTemplate {
        switch self {
        case .watchLand:
            return .watching2Full
        case .watching2Full:
            return .full
        case .full:
            return .watching2Full
        case .watching2Full:
            return .watchLand
        default:
            fatalError()
        }
    }
    
    
    static let watch = LayoutCalcuTemplate(uiTemplates: UIMetricTemplate.watch)
    
    static let surf = LayoutCalcuTemplate(uiTemplates: UIMetricTemplate.surf)
    
    private static let watchLand = LayoutCalcuTemplate(uiTemplates: UIMetricTemplate.watchLand)
    
    private static let surfLand = LayoutCalcuTemplate(uiTemplates: UIMetricTemplate.surfLand)
    
    private static let watching2Full = LayoutCalcuTemplate(uiTemplates: UIMetricTemplate.watching2Full)
    
    private static let full = LayoutCalcuTemplate(uiTemplates: UIMetricTemplate.full)
    
    var uiTemplates: UIMetricTemplate
    
    private init(uiTemplates: UIMetricTemplate) {
        self.uiTemplates = uiTemplates
    }
    
    func center() -> CGPoint {
        return CGPoint(x: uiTemplates.itemWidth * CGFloat(initialCenter1.section + 2), y: uiTemplates.itemHeight * CGFloat(initialCenter1.row + 2))
    }
    
    func toggledTemplate() -> LayoutCalcuTemplate {
        return self === LayoutCalcuTemplate.watch ? LayoutCalcuTemplate.surf : LayoutCalcuTemplate.watch
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
    
    init(theCenter: IndexPath, theCenterPosition: CGPoint, theTemplate: LayoutCalcuTemplate) {
        center = theCenter
        centerPosition = theCenterPosition
        template = theTemplate
        super.init()
    }
    
    let center: IndexPath
    var centerPosition: CGPoint
    var template: LayoutCalcuTemplate
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
