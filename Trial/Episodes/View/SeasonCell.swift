//
//  EpisodeCell.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

let numberFormatter: NumberFormatter = {
   let r = NumberFormatter()
    r.locale = Locale(identifier: "zh_Hans_CN")
    r.numberStyle = .spellOut
    return r
}()

class SeasonCell: UICollectionViewCell {
    
    var seasonNumLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        seasonNumLabel = UILabel(frame: .zero)
        contentView.addSubview(seasonNumLabel)
        seasonNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: seasonNumLabel, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: seasonNumLabel, attribute: .centerY, multiplier: 1, constant: 0)])
        
        seasonNumLabel.textColor = UIColor.white
        seasonNumLabel.font = UIFont(name: "PingFangSC-Semibold", size: 16)
    }
    
    func setSeasonNum(_ num: Int) {
        let numString = numberFormatter.string(from: NSNumber(value:num))!
        seasonNumLabel.text = "第\(numString)季"
    }
}
