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

class RippleCell: UICollectionViewCell {
    
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
    
    weak var videoWithPlayer: VideoWithPlayerView!
    
    
    
    func loadImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func configure(with youtubeVideoData: YoutubeVideoData, playerView: VideoWithPlayerView) {
        loadImage(youtubeVideoData.thumbnail!)
        embedYTPlayer(playerView)
    }
    
    func embedYTPlayer(_ newVideoWithPlayer: VideoWithPlayerView) {
        videoWithPlayer = newVideoWithPlayer
        
        videoWithPlayer.frame = bounds
        videoWithPlayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(videoWithPlayer)
        videoWithPlayer.isHidden = true
        
        
        videoWithPlayer.videoView.delegate = self
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let timing = (layoutAttributes as! LayoutAttributes).timing
        alpha = timing + 0.5
        layer.borderWidth = bounds.width * 0.02 * timing
        layer.cornerRadius = bounds.width / ratioOfcornerRadiusAndWidth
    }
    
    @IBOutlet weak var label: UILabel!
}

extension RippleCell: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        videoWithPlayer.isHidden = false
    }
}
