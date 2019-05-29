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
            cell.clearContents()
            cell.positionId = indexPath
        }
        
        YoutubeManagers.shared.getDataOf(item: indexPath) { youtubeVideoData in
            DispatchQueue.main.async {
                guard cell.positionId == indexPath else {
                    return
                }
                
                cell.clearContents()
                
                cell.loadThumbnailImage(youtubeVideoData.thumbnail)
                
//                if let video = youtubeVideoData.videoView {
//                    cell.loadScreenshot(video.screenshot)
//                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            YoutubeManagers.shared.requestFor(item: item)
        }
    }
}
