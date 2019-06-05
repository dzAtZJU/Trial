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

// Network Layer
class YoutubeManagerV2 {
    
    // Genesis information
    private var videoId2ThumbnailURL: [VideoId: URLString]!
    
    // On need information
    // Cache. Can request by known information
    private let videoId2Data = NSCache<NSString, YoutubeVideoData>()
    
    private let videoId2View = NSCache<NSString, VideoWithPlayerView>()
    
    private var videoId2Completion = [VideoId: [(YoutubeVideoData) -> ()]]()
    
    // Data Dependency
    private let serialAccessQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private let youtubeOperationQueue = OperationQueue()
    
    static let shared = YoutubeManagerV2()
    private init() {}
    
    func fetchVideo(_ videoId: VideoId, completion: ((VideoWithPlayerView, Bool) -> ())? = nil) {
        var videoView = videoId2View.object(forKey: videoId as NSString)
        let cached = videoView != nil
        if !cached {
            videoView = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
        }
        videoId2View.setObject(videoView!, forKey: videoId as NSString)
        if let completion = completion {
            completion(videoView!, cached)
        }
    }
    
    func batchRequest(_ videoIds: [VideoId]) {
        let thumbnailsUrlsOperation = ThumbnailsUrlsOperation(videoIds: videoIds)
        thumbnailsUrlsOperation.completionBlock = {
            if self.videoId2ThumbnailURL == nil {
                self.videoId2ThumbnailURL = [VideoId: URLString]()
            }
            self.videoId2ThumbnailURL.merge(thumbnailsUrlsOperation.videoId2ThumbnailUrl, uniquingKeysWith: { (first, _ ) in first })
        }
        serialAccessQueue.addOperation(thumbnailsUrlsOperation)
    }
    
    func request(_ videoId: VideoId, completion: ((YoutubeVideoData) -> ())? = nil) {
        self.serialAccessQueue.addOperation {
            if let completion = completion {
                self.videoId2Completion[videoId, default: []] += [completion]
            }
            
            guard self.operation(for: videoId) == nil else {
                return
            }
            
            if let videoData = self.videoId2Data.object(forKey: videoId as NSString ) {
                self.invokeVideoDataCompletion(for: videoId, with: videoData)
                return
            }
            
            let operation = ImageFetchOperation(urlString: self.videoId2ThumbnailURL[videoId], videoId: videoId)
            operation.completionBlock = {
                let data = YoutubeVideoData()
                data.videoId = videoId
                data.thumbnail = operation.image
                self.videoId2Data.setObject(data, forKey: videoId as NSString)
                self.invokeVideoDataCompletion(for: videoId, with: data)
            }
            self.youtubeOperationQueue.addOperation(operation)
        }
    }
    
    func get(_ videoId: VideoId, completion: @escaping (YoutubeVideoData) -> ()) {
        if let data = videoId2Data.object(forKey: videoId as NSString) {
            completion(data)
            return
        }
        
        request(videoId, completion: completion)
    }
    
    private func operation(for identifier: VideoId) -> ImageFetchOperation? {
        for case let fetchOperation as ImageFetchOperation in youtubeOperationQueue.operations
            where !fetchOperation.isCancelled && fetchOperation.videoId == identifier {
                return fetchOperation
        }
        
        return nil
    }
    
    private func invokeVideoDataCompletion(for videoId: VideoId, with fetchedData: YoutubeVideoData) {
        let completionHandlers = videoId2Completion[videoId, default: []]
        videoId2Completion[videoId] = nil
        
        for completionHandler in completionHandlers {
            completionHandler(fetchedData)
        }
    }
}