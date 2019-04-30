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
    
    var button: UIButton!
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 30)))
        label.backgroundColor = UIColor.white
        addSubview(label)
        
        button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 600, y: 300, width: 100, height: 50)
        button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        addSubview(button)
        
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        

    }
    
    @objc func handleButton() {
        NotificationCenter.default.post(name: .goToEpisodesView, object: self)
    }
}
