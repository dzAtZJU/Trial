//
//  EpisodeCell.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics



class EpisodeCell: VideoCellV2 {
    
    static let (aspectFull, aspectScale) = watch2Full(watching: watchingSize, fullscreen: screenSize)
    
    private let episodeNumMask: UIImageView
    
    let episodeNum: UILabel
    
    override init(frame: CGRect) {
        episodeNumMask = UIImageView()
        episodeNum = UILabel()
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        gradientView.image = UIImage(named: "episode_mask")
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupEpisodeNum()
    }
    
    private func setupEpisodeNum() {
        episodeNumMask.image = UIImage(named: "wedge_bg")
        setupImageView(episodeNumMask, at: 0, contentMode: .scaleToFill)
            
        episodeNum.textColor = UIColor.white.withAlphaComponent(0.24)
        episodeNum.font = UIFont(name: "PingFangSC-Semibold", size: 54)
        
        contentView.insertSubview(episodeNum, at: 0)
        
        episodeNum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: episodeNum, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: episodeNum, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    override func mountVideo(_ video: VideoWithPlayerView) {
        super.mountVideo(video)
        
        videoFullScreenOrNot = bounds.width >= (EpisodeCell.aspectFull.width - 10) // 10 for numeric error
    }
    
    override func addVideoToHierarchy(_ video: VideoWithPlayerView) {
        video.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(video, belowSubview: gradientView)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: video, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: EpisodeCell.aspectFull.height),
                                     NSLayoutConstraint(item: video, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: EpisodeCell.aspectFull.width),
                                     NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: video, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: video, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? EpisodeLayoutAttributes {
            contentView.layer.cornerRadius = attributes.radius
            contentFadeOutOrIn = attributes.hideContent
        }
    }
    
    var videoFullScreenOrNot: Bool {
        get {
            return true
        }
        set(newValue) {
            video?.transform = newValue ? .identity: CGAffineTransform(scaleX: 1 / EpisodeCell.aspectScale, y: 1 / EpisodeCell.aspectScale)
            video?.isUserInteractionEnabled = newValue
        }
    }
    
    var contentFadeOutOrIn: Bool {
        get {
            return true
        }
        set(newValue) {
            let newAlpha: CGFloat = newValue ? 0 : 1
            video?.alpha = newAlpha
            thumbnailView.alpha = newAlpha
            screenshot?.alpha = newAlpha
            gradientView.alpha = newAlpha
        }
    }
    
    var imageCenterOrFill: Bool {
        get {
            return true
        }
        set(newValue) {
            let contentMode: ContentMode = newValue ? .center : .scaleAspectFill
            thumbnailView.contentMode = contentMode
            screenshot?.contentMode = contentMode
        }
    }
}
