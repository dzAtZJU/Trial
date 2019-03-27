//
//  cgRectExtension.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics

infix operator *
extension CGRect {
    static func * (left: CGRect, right: CGFloat) -> CGRect {
        return CGRect(origin: left.origin * right, size: left.size * right)
    }
    static func + (left: CGRect, right: CGRect) -> CGRect {
        return CGRect(origin: left.origin + right.origin, size: left.size + right.size)
    }
}
