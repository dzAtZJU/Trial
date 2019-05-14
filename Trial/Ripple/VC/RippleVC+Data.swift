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
        if cell.positionId != indexPath {
            cell.clearContents()
            cell.positionId = indexPath
        }
        
        YoutubeManagers.shared.getData(indexPath: indexPath) { youtubeVideoData in
            DispatchQueue.main.async {
                guard cell.positionId == indexPath else {
                    return
                }
                
                cell.clearContents()
                
                cell.loadThumbnailImage(youtubeVideoData.thumbnail)
                
                if let video = self.videoId2PlayerView[youtubeVideoData.videoId!] {
                    cell.loadScreenshot(video.screenshot)
                }
            }
        }
        
        return cell
    }
    
    func preFetchVideoForTwoNeighborItems() {
        twoNeighborsOfInFocusItem().forEach { item in
            fetchVideoForItem(item) { video, cached in
                guard !cached else {
                    return
                }

                let cell = self.collectionView.cellForItem(at: item) as! RippleCellV2
                cell.mountVideoForBuffering(video)
            }
        }
    }
    
    func cancelPreFetchVideoForTwoNeighborItems() {
        twoNeighborsOfInFocusItem().forEach { item in
            fetchVideoForItem(item) { video, cached in
                guard !cached else {
                    return
                }

                let cell = self.collectionView.cellForItem(at: item) as! RippleCellV2
                cell.unmountVideoForBuffering()
            }
        }
    }
    
    func fetchVideoForItem(_ indexPath: IndexPath, completion: ((VideoWithPlayerView, Bool) -> ())? = nil) {
        YoutubeManagers.shared.getData(indexPath: indexPath) { youtubeVideoData in
            let videoId = youtubeVideoData.videoId!
            let cached = self.videoId2PlayerView[videoId] != nil
            if !cached {
                let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
                self.videoId2PlayerView[videoId] = player
            }
            if let completion = completion {
                completion(self.videoId2PlayerView[videoId]!, cached)
            }
        }
    }
}
