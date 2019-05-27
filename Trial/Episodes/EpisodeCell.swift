//
//  EpisodeCell.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class EpisodeCell: UICollectionViewCell {
    
    var episodeNum: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4) // 20 / 255
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let wedgeLight = UIImageView(image: UIImage(named: "wedge_light"))
        wedgeLight.contentMode = .scaleToFill
        wedgeLight.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wedgeLight)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: wedgeLight, attribute: .width, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: wedgeLight, attribute: .height, multiplier: 1, constant: 0)])
        
        episodeNum = UILabel(frame: .zero)
        episodeNum.textColor = UIColor.white.withAlphaComponent(0.24)
        episodeNum.font = UIFont(name: "PingFangSC-Semibold", size: 54)
        contentView.addSubview(episodeNum)
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
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return size
//    }
}
