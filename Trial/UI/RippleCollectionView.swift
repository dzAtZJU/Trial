//
//  RippleCollectionView.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/25.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class RippleCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    var transitionDirection: Direction?
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
