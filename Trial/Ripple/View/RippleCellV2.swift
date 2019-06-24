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

class RippleCellV2: VideoCellV2 {
    private var titleWatch: UILabel!
    private var subtitleWatch: UILabel!
    private var subtitleWatchBottomConstraint: NSLayoutConstraint!
    private var titleSurf: UILabel!
    private var subtitleSurf: UILabel!
    private var subtitleSurfBottomConstraint: NSLayoutConstraint!
    
    var positionId: IndexPath!
    
    private var shouldPlay = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        thumbnailView.contentMode = .scaleAspectFill
        gradientView.image = UIImage(named: "episode_mask")
        setupTitles()
    }
    
    func loadThumbnailImage(_ image: UIImage?) {
        thumbnailView.image = image
        if screenshot == nil {
            let copyOfThumbnail = UIImageView(image: image)
            copyOfThumbnail.contentMode = .scaleAspectFill
            addScreenshotToHierarchy(copyOfThumbnail)
        }
    }
    
    override func addScreenshotToHierarchy(_ image: UIView?) {
        guard let image = image else {
            return
        }
        
        screenshot?.removeFromSuperview()
        
        defer {
            screenshot = image
        }
        
        image.frame = bounds
        image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.insertSubview(image, aboveSubview: thumbnailView)
    }
    
    override func addVideoToHierarchy(_ newVideoWithPlayer: VideoWithPlayerView) {
        // Frame Based Layout
        newVideoWithPlayer.translatesAutoresizingMaskIntoConstraints = true
        
        // Anchor POint
        newVideoWithPlayer.layer.anchorPoint = .zero
        
        newVideoWithPlayer.bounds = CGRect(origin: .zero, size: CGSize(width: screenHeight, height: screenWidth))
        newVideoWithPlayer.center = .zero
        
        // Transform
        newVideoWithPlayer.transform = CGAffineTransform(scaleX: bounds.width / newVideoWithPlayer.bounds.width, y: bounds.height / newVideoWithPlayer.bounds.height)
        
        contentView.insertSubview(newVideoWithPlayer, belowSubview: gradientView)
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
        } else if attributes.sceneState == .surfing {
            titleSurf.alpha = timing
            subtitleSurf.alpha = timing
            
            titleWatch.alpha = 0
            subtitleWatch.alpha = 0
        } else {
            titleSurf.alpha = 0
            subtitleSurf.alpha = 0
            
            titleWatch.alpha = 0
            subtitleWatch.alpha = 0
        }
        
        guard attributes.sceneState != .surfing else {
            screenshot?.alpha = 0
            thumbnailView.alpha = 1
            return
        }
        
        thumbnailView.alpha = 1 - timing
        screenshot?.alpha = timing
        /// Notice for cell reusing
    }
    
    func runDisplayAnimation(fullScreenOrNot: Bool) {
        gradientView.alpha = fullScreenOrNot ? 0 : 1
    }
    
    private func setupTitles() {
        subtitleWatch = UILabel(frame: .zero)
        subtitleWatch.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.watch.subtitleFontSize)
        subtitleWatch.text = "Cigerrete 2019-04"
        subtitleWatch.textColor = UIColor.white
        contentView.addSubview(subtitleWatch)
        subtitleWatch.alpha = 1
        subtitleWatch.translatesAutoresizingMaskIntoConstraints = false
        subtitleWatchBottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subtitleWatch, attribute: .bottom, multiplier: 1, constant: UIMetricTemplate.watch.titlesBottom)
        self.addConstraints([subtitleWatchBottomConstraint,
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subtitleWatch, attribute: .centerX, multiplier: 1, constant: 0)])
        
        titleWatch = UILabel(frame: .zero)
        titleWatch.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.watch.titleFontSize)
        titleWatch.textColor = UIColor.white
        titleWatch.text = "音乐"
        contentView.addSubview(titleWatch)
        titleWatch.alpha = 1
        titleWatch.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: titleWatch, attribute: .bottom, relatedBy: .equal, toItem: subtitleWatch, attribute: .top, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: titleWatch, attribute: .centerX, multiplier: 1, constant: 0)])
        
        subtitleSurf = UILabel(frame: .zero)
        subtitleSurf.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.surf.subtitleFontSize)
        subtitleSurf.text = "Cigerrete 2019-04"
        subtitleSurf.textColor = UIColor.white
        contentView.addSubview(subtitleSurf)
        subtitleSurf.alpha = 0
        subtitleSurf.translatesAutoresizingMaskIntoConstraints = false
        subtitleSurfBottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: subtitleSurf, attribute: .bottom, multiplier: 1, constant: UIMetricTemplate.surf.titlesBottom)
        self.addConstraints([subtitleSurfBottomConstraint,
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subtitleSurf, attribute: .centerX, multiplier: 1, constant: 0)])
        
        titleSurf = UILabel(frame: .zero)
        titleSurf.font = UIFont(name: "PingFangSC-Regular", size: UIMetricTemplate.surf.titleFontSize)
        titleSurf.textColor = UIColor.white
        titleSurf.text = "音乐"
        contentView.addSubview(titleSurf)
        titleSurf.alpha = 0
        titleSurf.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: titleSurf, attribute: .bottom, relatedBy: .equal, toItem: subtitleSurf, attribute: .top, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: titleSurf, attribute: .centerX, multiplier: 1, constant: 0)])
    }
//    /// For debug
//    @IBOutlet weak var label: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}
