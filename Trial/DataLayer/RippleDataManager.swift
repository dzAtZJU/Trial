//
//  RippleDataManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

struct RippleDataManager {
    
    var item2VideoId: [IndexPath:VideoId]
    
    static func load(userId: String, completion: (RippleDataManager) -> ()) throws {
        let data = RippleDataManager(item2VideoId: TestDatas.indexPathToVideoId)
        completion(data)
    }
    
    mutating func setVideoId(at: IndexPath, videoId: VideoId) {
        item2VideoId[at] = videoId
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .rippleItemChange, object: nil, userInfo: ["item": at])
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
