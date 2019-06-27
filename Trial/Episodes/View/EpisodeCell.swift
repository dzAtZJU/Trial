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
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        contentView.layer.cornerRadius = 8
            
        gradientView.image = UIImage(named: "episode_mask")
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupEpisodeNum()
        
        setContentHide(true)
        setGradientHide(true)
    }
    
    private func setupEpisodeNum() {
        episodeNumMask.backgroundColor = UIColor.black.withAlphaComponent(0)
        episodeNumMask.image = UIImage(named: "wedge_bg")
        setupImageView(episodeNumMask, at: 0, contentMode: .scaleToFill)
            
        episodeNum.textColor = UIColor.white.withAlphaComponent(0.24)
        episodeNum.font = UIFont(name: "PingFangSC-Semibold", size: 54)
        
        contentView.insertSubview(episodeNum, aboveSubview: episodeNumMask)
        
        episodeNum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: episodeNum, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: episodeNum, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    override func addVideoToHierarchy(_ video: VideoWithPlayerView) {
        // Constraint Base Layout
        video.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.insertSubview(video, belowSubview: gradientView)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: video, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: EpisodeCell.aspectFull.height),
                                     NSLayoutConstraint(item: video, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: EpisodeCell.aspectFull.width),
                                     NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: video, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: video, attribute: .centerY, multiplier: 1, constant: 0)])
        
        video.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        layoutVideo(isFull: bounds.width >= (EpisodeCell.aspectFull.width - 10))
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? EpisodeLayoutAttributes {
//            contentView.layer.cornerRadius = attributes.radius
//            setContentHide(attributes.hideContent)
//            setGradientHide(attributes.hideContent)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.05) {
                self.episodeNum.textColor = UIColor.white.withAlphaComponent(self.isHighlighted ? 1 : 0.24)
                self.episodeNumMask.backgroundColor = UIColor.black.withAlphaComponent(self.isHighlighted ? 0.2 : 0)
                self.contentView.layer.borderWidth = self.isHighlighted ? 1 : 0
            }
        }
    }
    
    func configure4Full() {
        setContentHide(false)
        setGradientHide(true)
        contentView.layer.cornerRadius = 0
    }
    
    func animate2Full() {
        layoutVideo(isFull: true)
        setGradientHide(true)
        contentView.layer.cornerRadius = 0
    }
    
    func animate2Watching() {
        layoutVideo(isFull: false)
        setContentHide(false)
        setGradientHide(false)
        contentView.layer.cornerRadius = 14
        isHighlighted = false
    }
    
    func animate2Sliding() {
        setContentHide(true)
        setGradientHide(true)
        contentView.layer.cornerRadius = 8
        isHighlighted = true
    }
    
    private func layoutVideo(isFull: Bool) {
        video?.transform = isFull ? .identity : CGAffineTransform(scaleX: 1 / EpisodeCell.aspectScale, y: 1 / EpisodeCell.aspectScale)
        video?.isUserInteractionEnabled = isFull
    }
    
    private func setContentHide(_ isHide: Bool) {
        let newAlpha = CGFloat(isHide ? 0 : 1)
        
        video?.alpha = newAlpha
        thumbnailView.alpha = newAlpha
    }
    
    private func setGradientHide(_ isHide: Bool) {
        gradientView.alpha = isHide ? 0 : 1
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
