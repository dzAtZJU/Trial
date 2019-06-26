//
//  MyApplication.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/25.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class MyApplication: UIApplication {
    override func sendEvent(_ event: UIEvent) {
        defer {
            super.sendEvent(event)
        }
        
        if PlayerControlView.shared.superview == nil || event.type != .touches {
            return
        }
        
        var invalidateTimer = false
        var startTimer = true
        if let touches = event.allTouches {
            for touch in touches {
                if touch.phase == .began {
                    invalidateTimer = true
                    break
                }
                if touch.phase != .ended && touch.phase != .cancelled {
                    startTimer = false
                    break
                }
            }
        }
        
        if invalidateTimer {
            PlayerControlView.shared.delegate?.invalidatePlayerControlTimer()
        } else if startTimer {
            PlayerControlView.shared.delegate?.setupPlayerControlTimer()
        }
    }
}
