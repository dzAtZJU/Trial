//
//  ViewMorphing.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

/// Translation first!
func viewMorphing(inV: UIView, outV: UIView) -> (CGAffineTransform, CGAffineTransform) {
    let outCenter = outV.center
    let inCenter = inV.center
    let translation = CGAffineTransform(translationX: inCenter.x - outCenter.x, y: inCenter.y - outCenter.y)
    
    let outSize = outV.bounds.size
    let inSize = inV.bounds.size
    let scale = CGAffineTransform(scaleX: inSize.width / outSize.width, y: inSize.height / outSize.height)
    
    return (translation, scale)
}

func addViewMorphing(inV: UIView, outV: UIView, inVBottomConstraint: NSLayoutConstraint?, outVBottomConstraint: NSLayoutConstraint?, inVAlphaAnimator: UIViewPropertyAnimator, outVAlphaAnimator: UIViewPropertyAnimator, transformAnimator: UIViewPropertyAnimator) {
    let (translation, scale) = viewMorphing(inV: inV, outV: outV)
    inV.alpha = 0
    inV.transform = translation.concatenating(scale).inverted()
    inVAlphaAnimator.addAnimations {
        inV.alpha = 1
    }
    outVAlphaAnimator.addAnimations {
        outV.alpha = 0.5
    }
    outVAlphaAnimator.addCompletion { _ in
        outV.alpha = 0
    }
    transformAnimator.addAnimations {
        inV.transform = .identity
        outV.transform = scale
        if let inVBottomConstraint = inVBottomConstraint, let outVBottomConstraint = outVBottomConstraint {
            outVBottomConstraint.constant = inVBottomConstraint.constant
            outV.superview?.layoutIfNeeded()
        }
    }
}
