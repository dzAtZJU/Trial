//
//  RippleVC+Data.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

extension RippleVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    /// Configure global cell contents, that is, each cell has such contents
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCellV2
        cell.positionId = indexPath
        
        YoutubeManagers.shared.getData(indexPath: indexPath) { youtubeVideoData in
            DispatchQueue.main.async {
                guard cell.positionId == indexPath else {
                    return
                }
                
                cell.loadThumbnailImage(youtubeVideoData.thumbnail)
            }
        }
        
        return cell
    }
    
    func preFetchVideoForTwoNeighborItems() {
        twoNeighborsOfInFocusItem().forEach {
            fetchVideoForItem($0)
        }
    }
    
    func fetchVideoForItem(_ indexPath: IndexPath, completion: ((VideoWithPlayerView) -> ())? = nil) {
        YoutubeManagers.shared.getData(indexPath: indexPath) { youtubeVideoData in
            DispatchQueue.main.async {
                let videoId = youtubeVideoData.videoId!
                if self.videoId2PlayerView[videoId] == nil {
                    let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
                    self.videoId2PlayerView[videoId] = player
                }
                if let completion = completion {
                    completion(self.videoId2PlayerView[videoId]!)
                }
            }
        }
    }
}
