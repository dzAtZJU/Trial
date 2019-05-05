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

class RippleCell: UICollectionViewCell, VideoContainer {
    
    /// Identifier for asyn contents
    var positionId: IndexPath!
    
    /// One of global contents
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    /// One of timing contents
    var screenshotView: UIImageView!
    
    var videoWithPlayer: VideoWithPlayerView? {
        didSet {
            if shouldPlay {
                videoWithPlayer?.play()
                shouldPlay = false
            }
        }
    }
    
    var gradientView: UIView!
    
    var titleWatch: UILabel!
    
    var subtitleWatch: UILabel!
    var subtitleWatchBottomConstraint: NSLayoutConstraint!
    
    var titleSurf: UILabel!
    
    var subtitleSurf: UILabel!
    var subtitleSurfBottomConstraint: NSLayoutConstraint!
    
    
    
    /// One place to configure timing contents
    func handleUserEnter(video: VideoWithPlayerView) {
        embedYTPlayer(video)
        video.play()
    }
    
    /// One place to configure timing contents
    func handleUserLeave() {
        guard rippleViewStore.state.scene == .watching else {
            return
        }
        
        if let videoWithPlayer = videoWithPlayer {
            videoWithPlayer.getVideoState { state in
                guard state == WKYTPlayerState.playing else {
                    return
                }
                self.screenshotView.image = videoWithPlayer.screenshot
            }
            videoWithPlayer.fallOff()
            self.videoWithPlayer = nil
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
    
    func addSceneTransitionAnimation(toScene: RippleSceneState, duration: TimeInterval) -> [UIViewPropertyAnimator] {
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
        let outVAlphaAnimator = UIViewPropertyAnimator(duration: duration / 4, curve: .easeInOut)
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
        
        setupScreenshotView()
        setupGradientMask()
        setupTitles()
    }
    
    private func setupScreenshotView() {
        screenshotView = UIImageView()
        addSubview(screenshotView)
        screenshotView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: screenshotView, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: screenshotView, attribute: .trailing, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: screenshotView, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: screenshotView, attribute: .bottom, multiplier: 1, constant: 0)])
    }
    
    private func setupGradientMask() {
        gradientView = GradientView()
        addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: gradientView, attribute: .leading, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: gradientView, attribute: .trailing, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: gradientView, attribute: .top, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: gradientView, attribute: .bottom, multiplier: 1, constant: 0)])
    }
    
    private func setupTitles() {
        subtitleWatch = UILabel(frame: .zero)
        subtitleWatch.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.watch.subtitleFontSize)
        subtitleWatch.text = "Cigerrete 2019-04"
        subtitleWatch.textColor = UIColor.white
        addSubview(subtitleWatch)
        subtitleWatch.alpha = 1
        subtitleWatch.translatesAutoresizingMaskIntoConstraints = false
        subtitleWatchBottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subtitleWatch, attribute: .bottom, multiplier: 1, constant: UIMetricTemplate.watch.titlesBottom)
        self.addConstraints([subtitleWatchBottomConstraint,
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subtitleWatch, attribute: .centerX, multiplier: 1, constant: 0)])
        
        titleWatch = UILabel(frame: .zero)
        titleWatch.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.watch.titleFontSize)
        titleWatch.textColor = UIColor.white
        titleWatch.text = "音乐"
        addSubview(titleWatch)
        titleWatch.alpha = 1
        titleWatch.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: titleWatch, attribute: .bottom, relatedBy: .equal, toItem: subtitleWatch, attribute: .top, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: titleWatch, attribute: .centerX, multiplier: 1, constant: 0)])
        
        subtitleSurf = UILabel(frame: .zero)
        subtitleSurf.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.surf.subtitleFontSize)
        subtitleSurf.text = "Cigerrete 2019-04"
        subtitleSurf.textColor = UIColor.white
        addSubview(subtitleSurf)
        subtitleSurf.alpha = 0
        subtitleSurf.translatesAutoresizingMaskIntoConstraints = false
        subtitleSurfBottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subtitleSurf, attribute: .bottom, multiplier: 1, constant: UIMetricTemplate.surf.titlesBottom)
        self.addConstraints([subtitleSurfBottomConstraint,
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subtitleSurf, attribute: .centerX, multiplier: 1, constant: 0)])
        
        titleSurf = UILabel(frame: .zero)
        titleSurf.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.surf.titleFontSize)
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
        
        self.insertSubview(self.videoWithPlayer!, belowSubview: gradientView)
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
            
            titleSurf.alpha = 0
            subtitleSurf.alpha = 0
        } else {
            titleSurf.alpha = timing
            subtitleSurf.alpha = timing
            
            titleWatch.alpha = 0
            subtitleWatch.alpha = 0
        }
    
        guard attributes.sceneState == .watching else {
            screenshotView?.alpha = 0
            thumbnailImageView.alpha = 1
            return
        }
        if screenshotView.image != nil {
            thumbnailImageView.alpha = 1 - timing
            screenshotView.alpha = timing
        }
        /// Notice for cell reusing
    }
    /// For debug
    @IBOutlet weak var label: UILabel!
}
