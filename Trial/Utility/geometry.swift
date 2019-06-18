//
//  graphics.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/17.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    func moreHorizontal() -> Bool {
        if self.x == 0 {
            return false
        }
        
        let tan = self.y / self.x
        return  tan < 1 && tan > -1
    }
}
