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
    
    /// Identifier for asyn contents
    var positionId: IndexPath!
    
    /// One of global contents
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    /// One of timing contents
    var screenshotView: UIView?
    
    var titles: UIStackView!
    
    var titleLabel: UILabel!
    
    var subtitleLabel: UILabel!
    
    var titleBottomConstraint: NSLayoutConstraint!
    
    var videoWithPlayer: VideoWithPlayerView? {
        didSet {
            if shouldPlay {
                videoWithPlayer?.play()
            }
        }
    }
    
    /// One place to configure timing contents
    func handleUserEnter(video: VideoWithPlayerView) {
        embedYTPlayer(video)
        video.play()
    }
    
    /// One place to configure timing contents
    func handleUserLeave() {
        guard sceneState == .watching else {
            return
        }
        
        if let videoWithPlayer = videoWithPlayer {
            videoWithPlayer.fallOff()
            
            screenshotView?.removeFromSuperview()
            screenshotView  = videoWithPlayer.screenshot
            screenshotView!.frame = bounds
            screenshotView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(screenshotView!)
        }
    }
    
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
    
    func runTitlesAnimation(fontScale: CGFloat, bottom: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: fontScale, y: fontScale).concatenating(CGAffineTransform.init(translationX: 0, y: bottom))
            self.subtitleLabel.transform = CGAffineTransform(scaleX: fontScale, y: fontScale).concatenating(CGAffineTransform.init(translationX: 0, y: bottom))
        }, completion: { _ in
            self.titleLabel.transform = .identity
            self.subtitleLabel.transform = .identity
        })
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
        
        setupTitles()
    }
    
    private func setupTitles() {
        let stackView = UIStackView(frame: .zero)
        titles = stackView
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleBottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1, constant: UITemplates.current.titlesBottom)
        self.addConstraints([titleBottomConstraint,
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: stackView, attribute: .centerX, multiplier: 1, constant: 0)])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = UITemplates.current.titlesSpace
        titleLabel = UILabel(frame: .zero)
        subtitleLabel = UILabel(frame: .zero)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: UITemplates.current.titleFontSize)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "音乐"
        subtitleLabel.font = UIFont(name: "PingFangSC-Regular", size: UITemplates.current.subtitleFontSize)
        subtitleLabel.text = "Cigerrete 2019-04"
        subtitleLabel.textColor = UIColor.white
    }
    
    func loadThumbnailImage(_ image: UIImage?) {
        thumbnailImageView.image = image
    }
    
    func configure(with youtubeVideoData: YoutubeVideoData, playerView: VideoWithPlayerView) {
        loadThumbnailImage(youtubeVideoData.thumbnail)
        embedYTPlayer(playerView)
    }
    
    func embedYTPlayer(_ newVideoWithPlayer: VideoWithPlayerView) {
        self.videoWithPlayer = newVideoWithPlayer
        self.videoWithPlayer!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.videoWithPlayer!.backgroundColor = UIColor.yellow
        
        /// TODO: these are result from animation. Refactor later
        self.videoWithPlayer!.transform = .identity
        self.videoWithPlayer!.bounds = self.bounds
        self.videoWithPlayer!.center = self.bounds.center
        
        self.addSubview(self.videoWithPlayer!)
    }
    
    /// Apply layout to both Global and Timing Contents
    /// Since Timing Contents may be dirty, using layout to work around
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let attributes = layoutAttributes as! LayoutAttributes
        let timing = attributes.timing
        
//        layer.borderWidth = bounds.width * 0.02 * timing
        layer.cornerRadius = attributes.radius
        
        titleLabel.alpha = timing
        subtitleLabel.alpha = timing
        
        titleLabel.font = titleLabel.font.withSize(attributes.titleFontSize)
        subtitleLabel.font = subtitleLabel.font.withSize(attributes.subtitleFontSize)
        titleBottomConstraint.constant = attributes.titlesBottom
        
        guard attributes.sceneState == .watching else {
            screenshotView?.alpha = 0
            thumbnailImageView.alpha = 1
            return
        }
        if let screenshotView = screenshotView {
            thumbnailImageView.alpha = 1 - timing
            screenshotView.alpha = timing
        }
        /// Notice for cell reusing
    }
    /// For debug
    @IBOutlet weak var label: UILabel!
}
