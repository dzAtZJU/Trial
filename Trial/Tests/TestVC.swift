//
//  TestVC.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import CoreGraphics
import YoutubePlayer_in_WKWebView

class TestVC: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    var flag = true
    
    let animator = UIViewPropertyAnimator(duration: 2, curve: UIView.AnimationCurve.easeInOut, animations: nil)
    
    @IBAction func touched(_ sender: Any) {
        UIView.animate(withDuration: 2) {
            self.button.transform = self.flag ? CGAffineTransform(scaleX: 1.5, y: 1.5) : .identity
        }
        flag = !flag
    }
    
}
