//
//  SeasonsView.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/3.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class SeasonsView: UICollectionView {
    class func genSeasonsView() -> UICollectionView {
        let seasonsLayout = UICollectionViewFlowLayout()
        seasonsLayout.scrollDirection = .horizontal
        seasonsLayout.itemSize = CGSize(width: 100, height: 80)
        seasonsLayout.minimumInteritemSpacing = 75
        seasonsLayout.minimumLineSpacing = 75
        let seasonsView = UICollectionView(frame: .zero, collectionViewLayout: seasonsLayout)
        
        seasonsView.register(SeasonCell.self, forCellWithReuseIdentifier: "season")
        
        seasonsView.backgroundColor = UIColor.clear
        
        return seasonsView
    }
}


