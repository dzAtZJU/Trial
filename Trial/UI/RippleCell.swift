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
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var screenshotView: UIView?
    
    var titles: UIStackView!
    
    var titleLabel: UILabel!
    
    var subtitleLabel: UILabel!
    
    var positionId: IndexPath?
    
    var titleBottomConstraint: NSLayoutConstraint!
    
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
    
    weak var videoWithPlayer: VideoWithPlayerView! {
        didSet {
            if shouldPlay {
                videoWithPlayer.play()
            }
        }
    }
    
    func updateScreenShot() {
        guard let videoWithPlayer = videoWithPlayer else {
            return
        }
        screenshotView?.removeFromSuperview()
        screenshotView  = videoWithPlayer.snapshot()!
        screenshotView!.frame = bounds
        screenshotView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(screenshotView!)
    }
    
    func loadThumbnailImage(_ image: UIImage?) {
        thumbnailImageView.image = image
    }
    
    func configure(with youtubeVideoData: YoutubeVideoData, playerView: VideoWithPlayerView) {
        loadThumbnailImage(youtubeVideoData.thumbnail)
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
        let l = layoutAttributes as! LayoutAttributes
        let timing = l.timing
        
//        layer.borderWidth = bounds.width * 0.02 * timing
        layer.cornerRadius = l.radius
        
        titleLabel.alpha = timing
        subtitleLabel.alpha = timing
        
//        titleLabel.font = titleLabel.font.withSize(l.titleFontSize)
//        subtitleLabel.font = subtitleLabel.font.withSize(l.subtitleFontSize)
//        titleBottomConstraint.constant = l.titlesBottom
        
        if l.sceneState == .watching {
            if let screenshotView = screenshotView {
                thumbnailImageView.alpha = 1 - timing
                screenshotView.alpha = timing
            }
        } else {
            thumbnailImageView.alpha = 1
            screenshotView?.alpha = 0
        }
    }
    
    @IBOutlet weak var label: UILabel!
}
