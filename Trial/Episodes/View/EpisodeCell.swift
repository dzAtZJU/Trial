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
    
    let episodeNum: UILabel
    
    private let episodeNumMask: UIImageView
    
    override init(frame: CGRect) {
        episodeNum = UILabel()
        episodeNumMask = UIImageView()
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        gradientView.image = UIImage(named: "episode_mask")
        
        contentView.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4) // 20 / 255
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupEpisodeNum()
        
        hideContent = true
    }
    
    private func setupEpisodeNum() {
        episodeNumMask.image = UIImage(named: "wedge_light")
        setupImageView(episodeNumMask, at: 0)
            
        episodeNum.textColor = UIColor.white.withAlphaComponent(0.24)
        episodeNum.font = UIFont(name: "PingFangSC-Semibold", size: 54)
        
        contentView.insertSubview(episodeNum, at: 0)
        
        episodeNum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: episodeNum, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: episodeNum, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    
    override func addVideoToHierarchy(_ video: VideoWithPlayerView) {
        video.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(video, belowSubview: gradientView)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: video, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: watchingHeight),
                                     NSLayoutConstraint(item: video, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: watchingWidth),
                                     NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: video, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: video, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? EpisodeLayoutAttributes {
            contentView.layer.cornerRadius = attributes.radius
        }
    }
    
    var hideContent: Bool {
        get {
            return true
        }
        set(newValue) {
            let newAlpha: CGFloat = newValue ? 0 : 1
            thumbnailView.alpha = newAlpha
            screenshot?.alpha = newAlpha
            video?.alpha = newAlpha
            gradientView.alpha = newAlpha
        }
    }
    
    var videoFullScreen: Bool {
        get {
            return true
        }
        set(newValue) {
            let scaleX = screenHeight / bounds.width
            let scaleY = screenWidth / bounds.height
            video?.transform = newValue ? CGAffineTransform(scaleX: scaleX, y: scaleY) : CGAffineTransform.identity
        }
    }
    
    func toggleImageContentMode() {
        let newMode = thumbnailView.contentMode == .center ? ContentMode.scaleAspectFill : ContentMode.center
        thumbnailView.contentMode = newMode
        screenshot?.contentMode = newMode
        gradientView.contentMode = newMode
    }
}
