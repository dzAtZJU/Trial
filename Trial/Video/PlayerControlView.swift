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
    
    var exitButton: UIButton!
    
    var episodesButton: UIButton!
    
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
        
        exitButton = UIButton(type: .roundedRect)
        exitButton.backgroundColor = UIColor.red
        exitButton.frame = CGRect(x: 550, y: 0, width: 100, height: 50)
        addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        episodesButton = UIButton(type: .roundedRect)
        episodesButton.backgroundColor = UIColor.blue
        episodesButton.frame = CGRect(x: 550, y: 80, width: 100, height: 50)
        addSubview(episodesButton)
        episodesButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    }
    
    @objc func handleButton(_ sender: UIButton) {
        let notification = sender == exitButton ? Notification.Name.exitFullscreen : .goToEpisodesView
        NotificationCenter.default.post(name: notification, object: self)
    }
}
