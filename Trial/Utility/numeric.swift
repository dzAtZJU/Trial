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
        return limitIn(max: 1)
    }
    
    func limitIn(max: Float) -> Float {
        return self > max ? max : self < 0 ? 0 : self
    }
}
