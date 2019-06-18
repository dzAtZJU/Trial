//
//  PlayerPanRecognizer.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

enum PanPurpose {
    case leftVertical
    case rightVertical
    case horizontal
}

class PlayerPanRecognizer: NSObject {

    private(set) var diff: CGFloat! = nil
    
    private(set) var state = UIPanGestureRecognizer.State.possible
    
    private var purpose: PanPurpose! = nil
    
    private var lastLocation: CGPoint! = nil
    
    private lazy var purpose2Responder = [PanPurpose: (AnyObject, Selector)]()
    
    func addTargert(_ target: AnyObject, action: Selector, purpose: PanPurpose) {
        purpose2Responder[purpose] = (target, action)
    }
    
    private func locationChanged(_ newValue: CGPoint) {
        diff = purpose == .horizontal ? newValue.x - lastLocation.x : newValue.y - lastLocation.y
        lastLocation = newValue
    }
    
    private func clear() {
        purpose = nil
        lastLocation = nil
        diff = nil
        state = UIPanGestureRecognizer.State.possible
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            clear()
            
            lastLocation = sender.location(in: sender.view)
            if sender.velocity(in: sender.view).moreHorizontal() {
                purpose = .horizontal
            } else {
                purpose = lastLocation.x < sender.view!.bounds.midX ? PanPurpose.leftVertical : .rightVertical
            }
        case .changed:
            locationChanged(sender.location(in: sender.view))
        default:
            break
        }
        
        state = sender.state
        
        if let (target, action) = purpose2Responder[purpose] {
            target.perform(action, with: self)
        }
    }
}
