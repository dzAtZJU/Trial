//
//  YoutubeManagers.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/27.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class YoutubeManagers {
    
    static let shared = YoutubeManagers()
    
    func doInitialRequest() {
        loadVideoIds()
        
        let youtubeVideosThumbnailsUrlsOperation = YoutubeVideosThumbnailsUrlsOperation(videoIds: videoIds)
        youtubeVideosThumbnailsUrlsOperation.completionBlock = {
            let videoId2ThumbnailUrl = youtubeVideosThumbnailsUrlsOperation.videoId2ThumbnailUrl
            for (indexPath, thumbnailUrl) in videoId2ThumbnailUrl.enumerated() {
                indexPath2Data[indexPath]
            }
        }
        
//        for thumbnailUrl in Array(videoId2Thumbnail.values) {
//            let operation = ImageFetchOperation(imageUrl: thumbnailUrl)
//            operation.completionBlock = {
//                self.thumbnail2UIImage[thumbnailUrl] = operation.image!
//            }
//            operation.addDependency(youtubeVideosThumbnailsUrlsOperation)
//            YoutubeOperationQueue.addOperation(operation)
//        }
//
//        YoutubeOperationQueue.addOperation(youtubeVideosThumbnailsUrlsOperation)
    }

    var indexPath2Data = [IndexPath: YoutubeVideoData]()
    
    var videoIds: [VideoId] {
        return Array(indexPath2Data.values).map({ $0.videoId! })
    }
    
    private var indexPath2CompletionHandlers = [IndexPath: [(YoutubeVideoData) -> Void]]()
    
    func getData(indexPath: IndexPath, completionHandler: @escaping (YoutubeVideoData) -> Void) {
        let handlers = indexPath2CompletionHandlers[indexPath, default: []]
        indexPath2CompletionHandlers[indexPath] = handlers + [completionHandler]
        fetchData(indexPath: indexPath)
    }
    
    private func fetchData(indexPath: IndexPath) {
        if let data = indexPath2Data[indexPath] {
            invokeCompletionHandlers(for: indexPath, with: data)
            return
        }
    }
    
    private func invokeCompletionHandlers(for indexPath: IndexPath, with fetchedData: YoutubeVideoData) {
        let completionHandlers = indexPath2CompletionHandlers[indexPath, default: []]
        indexPath2CompletionHandlers[indexPath] = nil
        
        for completionHandler in completionHandlers {
            completionHandler(fetchedData)
        }
    }
    
    func loadVideoIds() {
        for row in 0..<ytRows {
            for col in 0..<ytCols {
                let indexPath = IndexPath(row: col, section: row)
                let videoData = YoutubeVideoData()
                videoData.videoId = "_uk4KXP8Gzw"
                indexPath2Data[indexPath] = videoData
            }
        }
    }
}
