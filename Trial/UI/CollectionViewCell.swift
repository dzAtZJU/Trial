//
//  CollectionViewCell.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView

class CollectionViewCell: UICollectionViewCell {
    
    weak var playerView: WKYTPlayerView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setPlayerView(_ newPlayerView: WKYTPlayerView) {
        if let playerView = playerView {
            playerView.removeFromSuperview()
        }
        
        newPlayerView.frame = bounds
        playerView = newPlayerView
        
        addSubview(playerView!)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        layer.borderWidth = bounds.width * 0.02 * CGFloat((layoutAttributes as! LayoutAttributes).timing)
        layer.cornerRadius = bounds.width / ratioOfcornerRadiusAndWidth
    }
    
    func setupView() {
        layer.borderColor = UIColor.white.cgColor
    }
}
