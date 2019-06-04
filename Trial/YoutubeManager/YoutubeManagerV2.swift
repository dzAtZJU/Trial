//
//  YoutubeManagers.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/27.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView

class YoutubeManagerV2 {
    
    // Cache. Can request by known information
    private let videoId2Data = NSCache<NSString, YoutubeVideoData>()
    
    private let videoId2View = NSCache<NSString, VideoWithPlayerView>()
    
    // Asyn Mechanism
    private var videoDataCompletion = [VideoId: [(YoutubeVideoData) -> ()]]()
    
    private let serialAccessQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private let youtubeOperationQueue = OperationQueue()
    
    /// Gloabal data warehouse for videos
    static let shared = YoutubeManagerV2()
    
    private init() {}
    
    func requestFor(item: IndexPath, completion: ((YoutubeVideoData) -> ())? = nil) {
        let videoId = indexPath2VideoId[item]!
        let operation = WaitingOperation() {
            if let completion = completion {
                let handlers = self.videoDataCompletion[videoId, default: []]
                self.videoDataCompletion[videoId] = handlers + [completion]
            }
            
            guard self.operation(for: videoId) == nil else {
                return
            }
            
            if let videoData = self.videoId2Data.object(forKey: videoId as NSString ) {
                self.invokeVideoDataCompletion(for: videoId, with: videoData)
                return
            }
            
            let operation = ImageFetchOperation(urlString: self.videoId2Thumbnail[videoId], videoId: videoId)
            operation.completionBlock = {
                let data = YoutubeVideoData()
                data.videoId = videoId
                data.thumbnail = operation.image
                self.videoId2Data.setObject(data, forKey: videoId as NSString)
                self.serialAccessQueue.addOperation {
                    self.invokeVideoDataCompletion(for: videoId, with: data)
                }
            }
            self.youtubeOperationQueue.addOperation(operation)
        }
        serialAccessQueue.addOperation(operation)
    }
}

// Youtube Video View
//extension YoutubeManager {
//    // Collectionview Level
//    func fetchVideoForItem(_ indexPath: IndexPath, completion: ((VideoWithPlayerView, Bool) -> ())? = nil) {
//        let videoId = indexPath2VideoId[indexPath]!
//        var videoView = videoId2View.object(forKey: videoId as NSString)
//        let cached = videoView != nil
//        if !cached {
//            videoView = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
//        }
//        videoId2View.setObject(videoView!, forKey: videoId as NSString)
//        if let completion = completion {
//            completion(videoView!, cached)
//        }
//    }
//}

//// Youtube Video Data
//extension YoutubeManager {
//    // Collectionview Level
//    func getDataOf(item: IndexPath, completionHandler: @escaping (YoutubeVideoData) -> ()) {
//        let videoId = indexPath2VideoId[item]!
//        if let data = videoId2Data.object(forKey: videoId as NSString) {
//            completionHandler(data)
//            return
//        }
//
//        requestFor(item: item, completion: completionHandler)
//    }
//

//
//    private func invokeVideoDataCompletion(for videoId: VideoId, with fetchedData: YoutubeVideoData) {
//        let completionHandlers = videoDataCompletion[videoId, default: []]
//        videoDataCompletion[videoId] = nil
//
//        for completionHandler in completionHandlers {
//            completionHandler(fetchedData)
//        }
//    }
//
//    private func operation(for identifier: VideoId) -> ImageFetchOperation? {
//        for case let fetchOperation as ImageFetchOperation in youtubeOperationQueue.operations
//            where !fetchOperation.isCancelled && fetchOperation.videoId == identifier {
//                return fetchOperation
//        }
//
//        return nil
//    }
//}
