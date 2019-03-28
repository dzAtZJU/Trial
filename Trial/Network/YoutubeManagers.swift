//
//  YoutubeManagers.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/27.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

typealias VideoId = String
typealias URLString = String

class YoutubeVideoData {
    var videoId: VideoId?
    var thumbnailUrl: URLString?
    var thumbnail: UIImage?
    var playerView: YTPlayerView?
}

class YoutubeManagers {
    
    static let shared = YoutubeManagers()
    
    func doInitialRequest() {
        YoutubeOperationQueue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        
        loadVideoIds()
        
        let thumbnailsUrlsOperation = ThumbnailsUrlsOperation(videoIds: Array(indexPath2videoId.values))
        thumbnailsUrlsOperation.completionBlock = {
            self.videoId2Thumbnail.merge(thumbnailsUrlsOperation.videoId2ThumbnailUrl, uniquingKeysWith: { (first, _ ) in first })
            for (videoId, thumbnailUrl) in self.videoId2Thumbnail {
                let operation = ImageFetchOperation(imageUrl: thumbnailUrl)
                operation.completionBlock = {
                    self.thumbnail2UIImage[thumbnailUrl] = operation.image!
                    let data = YoutubeVideoData()
                    data.videoId = videoId
                    data.thumbnail = operation.image!
                    self.videoId2Data[videoId] = data
                    self.invokeCompletionHandlers(for: videoId, with: data)
                }
                YoutubeOperationQueue.addOperation(operation)
            }
        }
        
        YoutubeOperationQueue.addOperation(thumbnailsUrlsOperation)
    }
    
    var indexPath2videoId = [IndexPath: VideoId]()
    
    var videoId2Thumbnail = [VideoId: URLString]()
    
    var thumbnail2UIImage = [URLString: UIImage]()

    var videoId2Data = [VideoId: YoutubeVideoData]()
    
    private var videoId2CompletionHandlers = [VideoId: [(YoutubeVideoData) -> Void]]()
    
    func getData(indexPath: IndexPath, completionHandler: @escaping (YoutubeVideoData) -> Void) {
        let videoId = indexPath2videoId[indexPath]!
        let handlers = videoId2CompletionHandlers[videoId, default: []]
        videoId2CompletionHandlers[videoId] = handlers + [completionHandler]
        fetchData(videoId: videoId)
    }
    
    private func fetchData(videoId: VideoId) {
        if let data = videoId2Data[videoId] {
            invokeCompletionHandlers(for: videoId, with: data)
            return
        }
    }
    
    private func invokeCompletionHandlers(for videoId: VideoId, with fetchedData: YoutubeVideoData) {
        let completionHandlers = videoId2CompletionHandlers[videoId, default: []]
        videoId2CompletionHandlers[videoId] = nil
        
        for completionHandler in completionHandlers {
            completionHandler(fetchedData)
        }
    }
    
    func loadVideoIds() {
        indexPath2videoId = TestDatas.indexPathToVideoId
    }
}
