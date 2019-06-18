//
//  controls.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/17.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

protocol HiddenSlider {
    func handle(state: UIPanGestureRecognizer.State, diff: CGFloat)
}
