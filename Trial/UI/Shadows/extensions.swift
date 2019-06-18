//
//  extensions.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func installShadowLayer(_ named: String) {
        let layer = CALayer()
        layer.contents = UIImage(named: named)?.cgImage
        layer.frame = bounds
        self.layer.insertSublayer(layer, at: 0)
    }
}
