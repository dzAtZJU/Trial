//
//  utility.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/13.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics

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


