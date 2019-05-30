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
        

        fatalError()
//        return validItems(candidates: possibleDIndex.map {
//            $0 + inFocusItem
//        }, maxRow: ytRows, maxCol: ytCols)
    }
    
    func updateContentInset() {
        let topInset = UIScreen.main.bounds.height / 3
        let leftInset = UIScreen.main.bounds.width / 3
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: topInset, right: leftInset)
    }
}
