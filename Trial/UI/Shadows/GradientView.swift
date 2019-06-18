//
//  GradientView.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor(white: 0, alpha: 0).cgColor, UIColor(white: 0, alpha: 0.8).cgColor]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
