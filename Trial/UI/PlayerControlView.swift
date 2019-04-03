//
//  PlayerView.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class PlayerControlView: UIView {
    let label: UILabel
    override init(frame: CGRect) {
        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 30)))
        label.backgroundColor = UIColor.white
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
