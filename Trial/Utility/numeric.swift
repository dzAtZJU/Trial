//
//  numeric.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation

extension Float {
    func limitInOne() -> Float {
        if self < 0 {
            return 0
        } else if self > 1 {
            return 1
        } else {
            return self
        }
    }
}
