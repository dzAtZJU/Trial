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

class VideoCell: UICollectionViewCell {
    
    /// One of global contents
    var thumbnailImageView: UIImageView!
    
    /// One of timing contents
    var screenshotView: UIImageView!
    
    private var gradientView: UIView!
    
    var videoWithPlayer: VideoWithPlayerView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.blue
        setupView()
    }
    
    func loadThumbnailImage(_ image: UIImage?) {
        thumbnailImageView.image = image
    }
    
    // One place to configure timing contents
    func mountVideo(_ video: VideoWithPlayerView) {
        setupVideoView(video)
        video.play()
    }
    
    /// One place to configure timing contents
    func unMountVideo() {
        guard let videoWithPlayer = videoWithPlayer else {
            return
        }
        
        self.screenshotView.image = videoWithPlayer.fallOff()
        self.videoWithPlayer = nil
    }
    
    private func setupView() {
        setupThumbnailImageView()
        setupScreenshotView()
        setupGradientMask()
    }
    
    private func setupThumbnailImageView() {
        thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        addSubview(thumbnailImageView)
        setupFillConstraintsFor(view: thumbnailImageView)
    }
    
    private func setupScreenshotView() {
        screenshotView = UIImageView()
        screenshotView.contentMode = .scaleAspectFill
        addSubview(screenshotView)
        setupFillConstraintsFor(view: screenshotView)
    }
    
    private func setupGradientMask() {
        gradientView = GradientView()
        addSubview(gradientView)
        setupFillConstraintsFor(view: gradientView)
    }
    
    private func setupVideoView(_ newVideoWithPlayer: VideoWithPlayerView) {
        newVideoWithPlayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        newVideoWithPlayer.frame = self.bounds
        self.videoWithPlayer = newVideoWithPlayer
        self.insertSubview(newVideoWithPlayer, belowSubview: gradientView)
    }
    
    private func setupFillConstraintsFor(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)])
    }
}
