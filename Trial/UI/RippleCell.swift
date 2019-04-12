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
    
    var titleWatch: UILabel!
    
    var subtitleWatch: UILabel!
    var subtitleWatchBottomConstraint: NSLayoutConstraint!
    
    var titleSurf: UILabel!
    
    var subtitleSurf: UILabel!
    var subtitleSurfBottomConstraint: NSLayoutConstraint!
    
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
    
    func addSceneTransitionAnimation(toScene: SceneState, duration: TimeInterval) -> [UIViewPropertyAnimator] {
        var inVOutVs = [(UIView, UIView, NSLayoutConstraint?, NSLayoutConstraint?)]()
        switch toScene {
            case .surfing:
                inVOutVs = [(titleSurf, titleWatch, nil, nil), (subtitleSurf, subtitleWatch, subtitleSurfBottomConstraint, subtitleWatchBottomConstraint)]
            case .watching:
                inVOutVs = [(titleWatch, titleSurf, nil, nil), (subtitleWatch, subtitleSurf, subtitleWatchBottomConstraint, subtitleSurfBottomConstraint)]
            default:
                fatalError("no such scene state")
        }
        let inVAlphaAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        let outVAlphaAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        let transformAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        
        for inVOutV in inVOutVs {
            addViewMorphing(inV: inVOutV.0, outV: inVOutV.1, inVBottomConstraint: inVOutV.2, outVBottomConstraint: inVOutV.3, inVAlphaAnimator: inVAlphaAnimator, outVAlphaAnimator: outVAlphaAnimator, transformAnimator: transformAnimator)
        }
        
        return [inVAlphaAnimator, outVAlphaAnimator, transformAnimator]
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
        
        setupGradientMask()
        setupTitles()
    }
    
    private func setupGradientMask() {
        let gradientView = GradientView()
        addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: gradientView, attribute: .leading, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: gradientView, attribute: .trailing, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: gradientView, attribute: .top, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: gradientView, attribute: .bottom, multiplier: 1, constant: 0)])
    }
    
    private func setupTitles() {
        subtitleWatch = UILabel(frame: .zero)
        subtitleWatch.font = UIFont(name: "PingFangSC-Regular", size: UITemplates.watch.subtitleFontSize)
        subtitleWatch.text = "Cigerrete 2019-04"
        subtitleWatch.textColor = UIColor.white
        addSubview(subtitleWatch)
        subtitleWatch.alpha = 1
        subtitleWatch.translatesAutoresizingMaskIntoConstraints = false
        subtitleWatchBottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subtitleWatch, attribute: .bottom, multiplier: 1, constant: UITemplates.watch.titlesBottom)
        self.addConstraints([subtitleWatchBottomConstraint,
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subtitleWatch, attribute: .centerX, multiplier: 1, constant: 0)])
        
        titleWatch = UILabel(frame: .zero)
        titleWatch.font = UIFont(name: "PingFangSC-Regular", size: UITemplates.watch.titleFontSize)
        titleWatch.textColor = UIColor.white
        titleWatch.text = "音乐"
        addSubview(titleWatch)
        titleWatch.alpha = 1
        titleWatch.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: titleWatch, attribute: .bottom, relatedBy: .equal, toItem: subtitleWatch, attribute: .top, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: titleWatch, attribute: .centerX, multiplier: 1, constant: 0)])
        
        subtitleSurf = UILabel(frame: .zero)
        subtitleSurf.font = UIFont(name: "PingFangSC-Regular", size: UITemplates.surf.subtitleFontSize)
        subtitleSurf.text = "Cigerrete 2019-04"
        subtitleSurf.textColor = UIColor.white
        addSubview(subtitleSurf)
        subtitleSurf.alpha = 0
        subtitleSurf.translatesAutoresizingMaskIntoConstraints = false
        subtitleSurfBottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subtitleSurf, attribute: .bottom, multiplier: 1, constant: UITemplates.surf.titlesBottom)
        self.addConstraints([subtitleSurfBottomConstraint,
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subtitleSurf, attribute: .centerX, multiplier: 1, constant: 0)])
        
        titleSurf = UILabel(frame: .zero)
        titleSurf.font = UIFont(name: "PingFangSC-Regular", size: UITemplates.surf.titleFontSize)
        titleSurf.textColor = UIColor.white
        titleSurf.text = "音乐"
        addSubview(titleSurf)
        titleSurf.alpha = 0
        titleSurf.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: titleSurf, attribute: .bottom, relatedBy: .equal, toItem: subtitleSurf, attribute: .top, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: titleSurf, attribute: .centerX, multiplier: 1, constant: 0)])
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
        
        if attributes.sceneState == .watching {
            titleWatch.alpha = timing
            subtitleWatch.alpha = timing
        } else {
            titleSurf.alpha = timing
            subtitleSurf.alpha = timing
        }
    
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
