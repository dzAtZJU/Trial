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

// Thumbnail + Gradient
class VideoCell: UICollectionViewCell {
    
    /// One of global contents
    var thumbnailImageView: UIImageView!
    
    /// One of timing contents
    var screenshotView: UIView!
    
    private var gradientView: UIView!
    
    var wkWebView: WKWebView!
    
    var videoWithPlayer: VideoWithPlayerView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.blue
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        backgroundColor = UIColor.blue
        setupView()
    }
    
    func clearContents() {
        thumbnailImageView.image = nil
        screenshotView.subviews.first?.removeFromSuperview()
    }
    
    func loadThumbnailImage(_ image: UIImage?) {
        thumbnailImageView.image = image
        if screenshotView.subviews.first == nil {
            let copyOfThumbnail = UIImageView(image: image)
            copyOfThumbnail.contentMode = .scaleAspectFill
            addScreenshotImage(copyOfThumbnail)
        }
    }
    
    func loadScreenshot(_ image: UIView?) {
        guard let image = image else {
            return
        }
        addScreenshotImage(image)
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
        screenshotView = UIView()
        addSubview(screenshotView)
        setupFillConstraintsFor(view: screenshotView)
    }
    
    private func setupGradientMask() {
        guard TestState != 1 else {
            return
        }
        gradientView = GradientView()
        addSubview(gradientView)
        setupFillConstraintsFor(view: gradientView)
    }
    
    func setupVideoView(_ newVideoWithPlayer: VideoWithPlayerView) {
        newVideoWithPlayer.layer.anchorPoint = .zero
        newVideoWithPlayer.bounds = CGRect(origin: .zero, size: CGSize(width: screenHeight, height: screenWidth))
        newVideoWithPlayer.transform = CGAffineTransform(scaleX: bounds.width / newVideoWithPlayer.bounds.width, y: bounds.height / newVideoWithPlayer.bounds.height)
        newVideoWithPlayer.videoView.isHidden = true
        addVideoToHierarchy(newVideoWithPlayer)
    }
    
    private func addScreenshotImage(_ image: UIView?) {
        guard let image = image else {
            return
        }
        
        image.frame = screenshotView.bounds
        image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        screenshotView.addSubview(image)
    }
    
    private func setupFillConstraintsFor(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)])
    }
}

// Video Operation
extension VideoCell {
    // One place to configure timing contents
    func mountVideo(_ video: VideoWithPlayerView) {
        setupVideoView(video)
        video.play()
        activityIndicator.startAnimating()
    }
    
    // mount, unmount 概念是基于交互来说的，在这里针对交互的要求来处理 video
    func unMountVideo() {
        guard let videoWithPlayer = videoWithPlayer else {
            return
        }
        
        guard videoWithPlayer.isReady else {
            videoWithPlayer.removeFromSuperview()
            self.videoWithPlayer = nil
            return
        }
        
        videoWithPlayer.fallOff()
        addScreenshotImage(videoWithPlayer.screenshot)
        self.videoWithPlayer = nil
    }
    
    func addVideoToHierarchy(_ video: VideoWithPlayerView) {
        self.videoWithPlayer = video
        if gradientView == nil {
            addSubview(video)
            return
        }
        self.insertSubview(video, belowSubview: gradientView)
    }
    
    func mountVideoForBuffering(_ video: VideoWithPlayerView) {
        setupVideoView(video)
        video.buffer()
    }
    
    func unmountVideoForBuffering() {
        guard let videoWithPlayer = videoWithPlayer else {
            return
        }
        
        videoWithPlayer.endBuffer()
    }
    
}
