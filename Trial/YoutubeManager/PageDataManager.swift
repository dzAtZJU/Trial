//
//  PageDataManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/4.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

// Data Flow
// 首屏：几季几集
// 滑动停止前：图片/视频 -> 只有这样，在滑动停止后，才会有徐徐展开的效果


class PageDataManager {
    
    private(set) var seasonsNum: Int! = nil
    
    private(set) var episodesNums: [Int]! = nil
    
    private(set) var item2VideoId: [IndexPath:VideoId]! = nil
    
    func genesisLoad() {
        seasonsNum = 5
        episodesNums = [6, 5, 5, 4, 4]
        item2VideoId = [IndexPath:VideoId]()
        for season in 0..<seasonsNum {
            for episode in 0..<episodesNums[season] {
                item2VideoId[IndexPath(row: episode, section: season)] = TestDatas.episodesIds[season][episode]
            }
        }
    }
    
    func fetchVideo(_ item: IndexPath, completion: ((VideoWithPlayerView, Bool) -> ())? = nil) {
        let videoId = self.item2VideoId[item]!
        YoutubeManagerV2.shared.fetchVideo(videoId, completion: completion)
    }
        
    func batchRequest(_ items: [IndexPath]) {
        let videoIds = items.map { self.item2VideoId[$0]! }
        YoutubeManagerV2.shared.batchRequest(videoIds)
    }
    
    func request(_ item: IndexPath, completion: ((YoutubeVideoData) -> ())? = nil) {
        let videoId = self.item2VideoId[item]!
        YoutubeManagerV2.shared.request(videoId, completion: completion)
    }
    
    func get(_ item: IndexPath, completion: @escaping (YoutubeVideoData) -> ()) {
        let videoId = self.item2VideoId[item]!
        YoutubeManagerV2.shared.get(videoId, completion: completion)
    }
}
