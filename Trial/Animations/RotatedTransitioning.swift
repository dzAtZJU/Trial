//
//  Rotate.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/26.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class RotatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let fromView: UIView
    let duration: TimeInterval
    let center: CGPoint
    
    init(fromView: UIView, center: CGPoint, duration: TimeInterval) {
        self.fromView = fromView
        self.duration = duration
        self.center = center
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)!
        toView.bounds = CGRect(x: 0, y: 0, width: self.fromView.bounds.height, height: self.fromView.bounds.width)
        toView.center = center
        toView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        
//        self.fromView.frame = toView.bounds
//        toView.addSubview(self.fromView)
        
        let canvas = transitionContext.containerView
        canvas.addSubview(toView)

        UIView.animate(withDuration: duration, animations: {
            let finaleFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            toView.bounds = finaleFrame
            toView.transform = CGAffineTransform.identity
            toView.center = CGPoint(x: finaleFrame.midX, y: finaleFrame.midY)
//            self.fromView.frame = toView.bounds
        }, completion: { finished in
            transitionContext.completeTransition(finished)
            print(toView.frame)
        })
    }
}
