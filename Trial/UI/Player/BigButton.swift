//
//  BigButton.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/24.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class BigButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -20, dy: -20).contains(point)
    }
}
