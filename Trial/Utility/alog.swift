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
    let det = (P2.y - P3.y) * (P1.x - P3.x) + (P3.x - P2.x) * (P1.y - P3.y)
    let c1 = ((P2.y - P3.y) * (P.x - P3.x) + (P3.x - P2.x) * (P.y - P3.y)) / det
    let c2 = ((P3.y - P1.y) * (P.x - P3.x) + (P1.x - P3.x) * (P.y - P3.y)) / det
    return [c1, c2, 1 - c1 - c2]
}

func isPointInTriangle(_ triangle: (CGPoint, CGPoint, CGPoint), point: CGPoint) -> Bool {
    let barycentric = barycentricOf(point, P1: triangle.0, P2: triangle.1, P3: triangle.2)
    return barycentric.allSatisfy {
        $0 > 0
    }
}
