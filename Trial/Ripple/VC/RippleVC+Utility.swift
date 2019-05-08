//
//  RippleVC+Utility.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

extension RippleVC {
    
    func twoNeighborsOfInFocusItem() -> [IndexPath] {
        let possibleDIndex = UIDevice.current.orientation.isPortrait ?
            [IndexPath(row: 1, section: 0), IndexPath(row: -1, section: 0)] :
        [IndexPath(row: 0, section: 1), IndexPath(row: 0, section: -1)]
        
        return validItems(candidates: possibleDIndex.map {
            $0 + inFocusItem
        }, maxRow: ytRows, maxCol: ytCols)
    }
}
