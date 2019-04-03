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
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard sceneState == .watching else { return }
//        if let _ = object as? RippleTransitionLayout, let change = change {
//            guard keyPath == "lastCenterP" else { return }
//
//            let oldCenter = change[.oldKey] as! IndexPath
//            let oldCell = cellForItem(at: oldCenter) as! RippleCell
//            oldCell.videoWithPlayer?.pause()
//
//            let newCenter = change[.newKey] as! IndexPath
//            let newCell = cellForItem(at: newCenter) as! RippleCell
//            newCell.videoWithPlayer?.play()
//        }
//    }
    
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
