//
//  RippleVC+Data.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

extension RippleVC: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    /// Configure global cell contents, that is, each cell has such contents
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCellV2
        if cell.positionId != indexPath {
            cell.positionId = indexPath
        }
        
        dataManager.batchRequest([indexPath] + eightNeighborsOf(item: indexPath, maxRow: ytRows, maxCol: ytCols))
        dataManager.get(indexPath) { youtubeVideoData in
            DispatchQueue.main.async {
                guard cell.positionId == indexPath else {
                    return
                }
                cell.title = youtubeVideoData.title
                cell.loadThumbnailImage(youtubeVideoData.thumbnail)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        dataManager.batchRequest(indexPaths)
        for item in indexPaths {
            dataManager.request(item)
        }
    }
}
