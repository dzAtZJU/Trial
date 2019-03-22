//
//  CollectionViewCell.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class RippleCell: UICollectionViewCell, YTPlayerWrapper {
    
    weak var playerView: YTPlayerView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func embedYTPlayer(_ newPlayerView: YTPlayerView) {
//        if let playerView = playerView {
//            playerView.removeFromSuperview()
//        }
        
        newPlayerView.frame = bounds
        newPlayerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        playerView = newPlayerView
        
        addSubview(playerView!)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let timing = (layoutAttributes as! LayoutAttributes).timing
        alpha = timing + 0.5
        layer.borderWidth = bounds.width * 0.02 * timing
        layer.cornerRadius = bounds.width / ratioOfcornerRadiusAndWidth
    }
    
    func setupView() {
        layer.borderColor = UIColor.white.cgColor
    }
    
    
    @IBOutlet weak var label: UILabel!
}
