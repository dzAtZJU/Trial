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

class RippleCell: UICollectionViewCell {
    
    var positionId: IndexPath?
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var titleLabel: UILabel!
    
    weak var subTitleLabel: UILabel!
    
    func play() {
        if let videoWithPlayer = videoWithPlayer {
            videoWithPlayer.play()
        } else {
            shouldPlay = true
        }
    }
    
    func pause() {
        if let videoWithPlayer = videoWithPlayer {
            videoWithPlayer.pause()
        } else {
            shouldPlay = false
        }
    }
    
    private var shouldPlay = false
    
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
        
        titleLabel = UILabel(frame: .zero)
    }
    
    weak var videoWithPlayer: VideoWithPlayerView! {
        didSet {
            if shouldPlay {
                videoWithPlayer.play()
            }
        }
    }
    
    
    func loadImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func configure(with youtubeVideoData: YoutubeVideoData, playerView: VideoWithPlayerView) {
        loadImage(youtubeVideoData.thumbnail)
        embedYTPlayer(playerView)
    }
    
    func embedYTPlayer(_ newVideoWithPlayer: VideoWithPlayerView) {
        DispatchQueue.main.async {
                self.videoWithPlayer = newVideoWithPlayer
                self.videoWithPlayer.transform = .identity
                self.videoWithPlayer.bounds = self.bounds
                self.videoWithPlayer.center = self.bounds.center
                self.videoWithPlayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                self.videoWithPlayer.backgroundColor = UIColor.yellow
                self.addSubview(self.videoWithPlayer)
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let timing = (layoutAttributes as! LayoutAttributes).timing
        alpha = timing + 0.5
        layer.borderWidth = bounds.width * 0.02 * timing
        layer.cornerRadius = bounds.width / ratioOfcornerRadiusAndWidth
    }
    
    @IBOutlet weak var label: UILabel!
}
