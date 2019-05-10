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

// 不同方向的下一个点
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

// 点的四个垂直三角
func indexTrianglesAround(_ point: CGPoint, maxRow: Int, maxCol: Int) -> [(CGPoint, CGPoint, CGPoint)] {
    let dPoints = [CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1), CGPoint(x: -1, y: 0), CGPoint(x: 0, y: -1)]
    return [(point, point + dPoints[0], point + dPoints[1]),
            (point, point + dPoints[1], point + dPoints[2]),
            (point, point + dPoints[2], point + dPoints[3]),
            (point, point + dPoints[3], point + dPoints[0])].filter({
                validItems(candidates: [IndexPath($0.0), IndexPath($0.1), IndexPath($0.2)], maxRow: maxRow, maxCol: maxCol).count == 3
            })
}

// 点的四个斜对面三角
func flipTrianglesAround(_ point: CGPoint, maxRow: Int, maxCol: Int) -> [(CGPoint, CGPoint, CGPoint)] {
    let dPoints = [CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1), CGPoint(x: -1, y: 0), CGPoint(x: 0, y: -1)]
    let dDiagonalPoints = [CGPoint(x: 1, y: 1), CGPoint(x: -1, y: 1), CGPoint(x: -1, y: -1), CGPoint(x: 1, y: -1)]
    return [(point + dPoints[0], point + dPoints[1], point + dDiagonalPoints[0]),
            (point + dPoints[1], point + dPoints[2], point + dDiagonalPoints[1]),
            (point + dPoints[2], point + dPoints[3], point + dDiagonalPoints[2]),
            (point + dPoints[3], point + dPoints[0], point + dDiagonalPoints[3])].filter({
                validItems(candidates: [IndexPath($0.0), IndexPath($0.1), IndexPath($0.2)], maxRow: maxRow, maxCol: maxCol).count == 3
                })
}

// 点的默认垂直三角
func defaultIndexTriangleAround(_ indexPath: IndexPath, maxRow: Int, maxCol: Int) -> (IndexPath, IndexPath, IndexPath) {
    let boundFilter: (IndexPath) -> Bool = {
        return $0.row >= 0 && $0.row < maxRow && $0.section >= 0 && $0.section < maxCol
    }
    
    let alongRows = [indexPath + IndexPath(row: -1, section: 0), indexPath + IndexPath(row: 1, section: 0)].filter(boundFilter)
    let alongCols = [indexPath + IndexPath(row: 0, section: 1), indexPath + IndexPath(row: 0, section: -1)].filter(boundFilter)

    return (indexPath, alongRows.first!, alongCols.first!)
}

// 垂直四个邻居点
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

// 界内的点
func validItems(candidates: [IndexPath], maxRow: Int, maxCol: Int) -> [IndexPath] {
    return candidates.filter({
        $0.row >= 0 && $0.row < maxRow && $0.section >= 0 && $0.section < maxCol
    })
}

func diagonalVertexOf(_ triangle: (CGPoint, CGPoint, CGPoint)) -> CGPoint {
    let decider: (CGPoint, CGPoint) -> Bool = {
        let diff = $0 - $1
        return abs(diff.x) > 0 && abs(diff.y) > 0
    }
    
    if decider(triangle.0, triangle.1) {
        return triangle.2
    }
    
    if decider(triangle.0, triangle.2) {
        return triangle.1
    }
    
    return triangle.0
}

func eightTrianglesAround(_ triangle: (CGPoint, CGPoint, CGPoint)) -> [(CGPoint, CGPoint, CGPoint)] {
    let diagonalVertex = diagonalVertexOf(triangle)
    return indexTrianglesAround(diagonalVertex, maxRow: ytRows, maxCol: ytCols) + flipTrianglesAround(diagonalVertex, maxRow: ytRows, maxCol: ytCols)
}
