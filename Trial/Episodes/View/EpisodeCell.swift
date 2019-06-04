//
//  EpisodeCell.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class EpisodeCell: ScreenshotCell {
    
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
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? EpisodeLayoutAttributes {
            contentView.layer.cornerRadius = attributes.radius
        }
    }
}
