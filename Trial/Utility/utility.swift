//
//  utility.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/13.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

let tan22_5: CGFloat = 0.414
let tan67_5: CGFloat = 2.41

enum Direction {
    case N
    case EN
    case E
    case ES
    case S
    case WS
    case W
    case WN
    
    static func fromVelocity(_ v: CGPoint) -> Direction {
        let x = v.x
        let y = v.y
        let tan = y / x
        if y >= 0 && (tan >= 1 || tan <= -1) {
            return .N
        } else if x >= 0 && tan <= 1 && tan >= -1 {
            return .W
        } else if y <= 0 && (tan >= 1 || tan <= -1) {
            return .S
        } else if  x <= 0 && tan <= 1 && tan >= -1 {
            return .E
        }
        
        return .N
    }
    
    static func fullDirectioinFromVelocity(_ v: CGPoint) -> Direction {
        let x = v.x
        let y = v.y
        let tan = y / x
        if y > 0 && (tan > tan67_5 || tan < -tan67_5) {
            return .S
        }
        else if x > 0 && y > 0 && tan > tan22_5 && tan < tan67_5 {
            return .WS
        }
        else if x > 0 && tan < tan22_5 && tan > -tan22_5 {
            return .W
        } else if x > 0 && y < 0 && tan < -tan22_5 && tan > -tan67_5 {
            return .WN
        } else if y < 0 && (tan > tan67_5 || tan < -tan67_5) {
            return .N
        } else if x < 0 && y < 0 && tan > tan22_5 && tan < tan67_5 {
            return .EN
        } else if  x < 0 && tan < tan22_5 && tan > -tan22_5 {
            return .E
        } else {
            return .ES
        }
    }
}

func nextItemOn(direction: Direction, currentItem: IndexPath, maxRow: Int, maxCol: Int) -> IndexPath {
    let currentRow = currentItem.row
    let currentCol = currentItem.section
    
    var nextRow: Int
    var nextCol: Int
    switch direction {
        case .N:
            (nextRow, nextCol) = boundedElement(row: currentRow - 1, col: currentCol, maxRow: maxRow, maxCol: maxCol)
        case .E:
            (nextRow, nextCol) = boundedElement(row: currentRow, col: currentCol + 1, maxRow: maxRow, maxCol: maxCol)
        case .S:
            (nextRow, nextCol) = boundedElement(row: currentRow + 1, col: currentCol, maxRow: maxRow, maxCol: maxCol)
        case .W, .EN, .ES, .WN, .WS:
            (nextRow, nextCol) = boundedElement(row: currentRow, col: currentCol - 1, maxRow: maxRow, maxCol: maxCol)
        
    }
    return IndexPath(row: nextRow, section: nextCol)
}

func boundedElement(row: Int, col: Int, maxRow: Int, maxCol: Int) -> (row: Int, col: Int) {
    return (max(0, min(row, maxRow)), max(0, min(col, maxCol)))
}

func normalizedDistanceToCenterOf(rec: CGRect, endPoint: CGPoint) -> CGFloat {
    let dY = endPoint.y - rec.midY
    let dX = endPoint.x - rec.midX
    let tanRay = dX != 0 ? dY / dX : CGFloat(Int.max)
    let absTanRay = abs(tanRay)
    
    let tanDiagonal = rec.height / rec.width
    
    if absTanRay < tanDiagonal {
        return abs(dX) / (rec.width / 2)
    } else {
        return abs(dY) / (rec.height / 2)
    }
}

func doIn2DRange(maxRow: Int, maxCol: Int, block: (Int, Int, inout Bool) -> Void) {
    var stop = false
    for row in 0..<maxRow {
        for col in 0..<maxCol {
            block(row, col, &stop)
            if stop {
                return
            }
        }
    }
}

//func doIn2DRange(startPoints: [(Int, Int)], maxRow: Int, maxCol: Int, block: (Int, Int) -> Void) {
//    var queue = startPoints
//    while let point = queue.first {
//        block(point.0, point.1)
//
//    }
//}

func indexTrianglesAround(_ point: CGPoint) -> [(CGPoint, CGPoint, CGPoint)] {
    let dPoints = [CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1), CGPoint(x: -1, y: 0), CGPoint(x: 0, y: -1)]
    return [(point, point + dPoints[0], point + dPoints[1]),
            (point, point + dPoints[1], point + dPoints[2]),
            (point, point + dPoints[2], point + dPoints[3]),
            (point, point + dPoints[3], point + dPoints[0])].filter({
                $0.0 >= CGFloat(0) && $0.1 >= CGFloat(0) && $0.2 >= CGFloat(0)
            })
}

func defaultIndexTriangleAround(_ indexPath: IndexPath, maxRow: Int, maxCol: Int) -> (IndexPath, IndexPath, IndexPath) {
    let boundFilter: (IndexPath) -> Bool = {
        return $0.row >= 0 && $0.row < maxRow && $0.section >= 0 && $0.section < maxCol
    }
    
    var alongRows = [indexPath + IndexPath(row: -1, section: 0), indexPath + IndexPath(row: 1, section: 0)].filter(boundFilter)
    var alongCols = [indexPath + IndexPath(row: 0, section: 1), indexPath + IndexPath(row: 0, section: -1)].filter(boundFilter)

    return (indexPath, alongRows.first!, alongCols.first!)
}

func nearestFiveTo(_ indexPath: IndexPath, maxRow: Int, maxCol: Int) -> [IndexPath] {
    var array: [IndexPath] = [indexPath,
                 indexPath + IndexPath(row: 0, section: 1),
                 indexPath + IndexPath(row: 0, section: -1),
                 indexPath + IndexPath(row: 1, section: 0),
                 indexPath + IndexPath(row: -1, section: 0)]
    
    array = array.filter({
        $0.row >= 0 && $0.row < maxRow && $0.section >= 0 && $0.section < maxCol
    })
    return Array(Set(array))
}
