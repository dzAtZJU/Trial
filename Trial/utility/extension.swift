//
//  extensioin.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics

extension IndexPath {
    static func + (left: IndexPath, right: IndexPath) -> IndexPath {
        return IndexPath(row: left.row + right.row, section: left.section + right.section)
    }
}

extension CGPoint {
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static func >= (left: CGPoint, right: CGFloat) -> Bool {
        return left.x >= right && left.y >= right
    }
}
extension CGSize {
    static func * (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width * right, height: left.height * right)
    }
    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
}

extension CGRect {
    static func * (left: CGRect, right: CGFloat) -> CGRect {
        return CGRect(origin: left.origin * right, size: left.size * right)
    }
    static func + (left: CGRect, right: CGRect) -> CGRect {
        return CGRect(origin: left.origin + right.origin, size: left.size + right.size)
    }
}
