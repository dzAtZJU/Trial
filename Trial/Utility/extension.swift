//
//  extensioin.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension IndexPath {
    static func + (left: IndexPath, right: IndexPath) -> IndexPath {
        return IndexPath(row: left.row + right.row, section: left.section + right.section)
    }
    init(_ cgpoint: CGPoint) {
        self.init(row: Int(cgpoint.y), section: Int(cgpoint.x))
    }
}

extension CGPoint {
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    static func >= (left: CGPoint, right: CGFloat) -> Bool {
        return left.x >= right && left.y >= right
    }
    init(_ indexPath: IndexPath) {
        self.init(x: indexPath.section, y: indexPath.row)
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

    var center: CGPoint { return CGPoint(x: midX, y: midY) }
    
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
}

func distanceBetween(left: CGPoint, right: CGPoint) -> CGFloat {
    let vector = left - right
    return hypot(vector.x, vector.y)
}

func indexOfMax(_ array: [CGFloat]) -> Int {
    var max = CGFloat(Int.min)
    var position = -1
    for (index,value) in array.enumerated(){
        if value > max {
            max = value
            position = index
        }
    }
    return position
}

extension UIScrollView {
    var viewPortCenter: CGPoint {
        return bounds.center
    }
}

extension UIDevice {
    func triggerInterfaceRotateForEixtFullscreen() {
        setValue(UIDeviceOrientation.portraitUpsideDown.rawValue, forKey: "orientation")
        setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    func triggerInterfaceRotateForFullscreen() {
        setValue(UIDeviceOrientation.portraitUpsideDown.rawValue, forKey: "orientation")
    }
}

extension UIWindow {
    func mountVideo(_ video: VideoWithPlayerView) {
        video.frame = bounds
        insertSubview(video, at: subviews.count - 1)
        video.play()
    }
}
