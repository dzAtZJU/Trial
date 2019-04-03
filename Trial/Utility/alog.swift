//
//  alog.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics

func barycentricOf(_ P:CGPoint, P1: CGPoint, P2: CGPoint, P3: CGPoint) -> [CGFloat] {
    let dY23 = P2.y - P3.y
    let dY13 = P1.y - P3.y
    let dX13 = P1.x - P3.x
    let dX32 = P3.x - P2.x
    let dX3 = P.x - P3.x
    let dY3 = P.y - P3.y
    let det = (dY23) * (dX13) + (dX32) * (dY13)
    
    let c1 = ((dY23) * (dX3) + (dX32) * (dY3)) / det
    let c2 = ((-dY13) * (dX3) + (dX13) * (dY3)) / det
    return [c1, c2, 1 - c1 - c2]
}

func isPointInTriangle(_ triangle: (CGPoint, CGPoint, CGPoint), point: CGPoint) -> Bool {
    let barycentric = barycentricOf(point, P1: triangle.0, P2: triangle.1, P3: triangle.2)
    return barycentric.allSatisfy {
        $0 > 0
    }
}
