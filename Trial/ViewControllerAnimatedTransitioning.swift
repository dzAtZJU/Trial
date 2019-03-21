//
//  ViewControllerAnimatedTransitioning.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/14.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let initialFrame: CGRect
    let duration: TimeInterval
    
    init(initialFrame: CGRect, duration: TimeInterval) {
        self.initialFrame = initialFrame
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toView = transitionContext.view(forKey: .to) {
            let canvas = transitionContext.containerView
            let targetFrame = toView.frame
            toView.frame = initialFrame
            canvas.addSubview(toView)
            UIView.animate(withDuration: duration, animations: {
                toView.frame = targetFrame
            }, completion: { finished in
                toView.layer.cornerRadius = 0
                transitionContext.completeTransition(finished)
            }
            )
        }
    }
}
