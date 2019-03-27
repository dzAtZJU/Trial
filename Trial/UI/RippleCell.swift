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
    
    var positionId: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        layer.borderColor = UIColor.white.cgColor
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var playerView: YTPlayerView?
    
    func embedYTPlayer(_ newPlayerView: YTPlayerView) {
        newPlayerView.frame = bounds
        newPlayerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        playerView = newPlayerView
        
        addSubview(playerView!)
    }
    
    func loadImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func configure(with youtubeVideoData: YoutubeVideoData?) {
        loadImage(youtubeVideoData!.thumbnail)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let timing = (layoutAttributes as! LayoutAttributes).timing
        alpha = timing + 0.5
        layer.borderWidth = bounds.width * 0.02 * timing
        layer.cornerRadius = bounds.width / ratioOfcornerRadiusAndWidth
    }
    
    @IBOutlet weak var label: UILabel!
}
