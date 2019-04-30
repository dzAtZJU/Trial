//
//  RippleCollectionView.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/25.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class RippleCollectionView: UICollectionView {
    
    var transitionDirection: Direction?
    
    var sceneState: SceneState = .initial {
        willSet {
            switch newValue {
                case .watching:
                    isDirectionalLockEnabled = true
                case .surfing :
                    isDirectionalLockEnabled = false
                default:
                    return
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        decelerationRate = UIScrollView.DecelerationRate.fast
        contentInsetAdjustmentBehavior = .never
        insetsLayoutMarginsFromSafeArea = false
    }
}

extension RippleCollectionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
