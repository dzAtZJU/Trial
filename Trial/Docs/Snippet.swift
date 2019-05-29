//
//  Snippet.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/29.
//  Copyright © 2019 周巍然. All rights reserved.
//

//import Foundation
//
//func preFetchVideoForTwoNeighborItems() {
//    twoNeighborsOfInFocusItem().forEach { item in
//        YoutubeManagers.shared.fetchVideoForItem(item) { video, cached in
//            guard !cached else {
//                return
//            }
//
//            let cell = self.collectionView.cellForItem(at: item) as! RippleCellV2
//            cell.mountVideoForBuffering(video)
//        }
//    }
//}
//
//func cancelPreFetchVideoForTwoNeighborItems() {
//    twoNeighborsOfInFocusItem().forEach { item in
//        YoutubeManagers.shared.fetchVideoForItem(item) { video, cached in
//            guard !cached else {
//                return
//            }
//
//            let cell = self.collectionView.cellForItem(at: item) as! RippleCellV2
//            cell.unmountVideoForBuffering()
//        }
//    }
//}

//for (videoId, thumbnailUrl) in self.videoId2Thumbnail {
//    let operation = ImageFetchOperation(imageUrl: thumbnailUrl)
//    operation.completionBlock = {
//        let data = YoutubeVideoData()
//        data.videoId = videoId
//        data.thumbnail = operation.image
//        self.videoId2Data[videoId] = data
//        DispatchQueue.main.sync {
//            self.invokeCompletionHandlers(for: videoId, with: data)
//        }
//    }
//    YoutubeOperationQueue.addOperation(operation)
//}

// Collectionview Level
//func batchRequestFor(items: [IndexPath]) {
//    for item in items {
//        let videoId = indexPath2videoId[item]!
//        requestFor(videoId: videoId) { youtubeVideoData in
//            self.videoId2Data[videoId] = youtubeVideoData
//            DispatchQueue.main.sync {
//                self.invokeCompletionHandlers(for: videoId, with: youtubeVideoData)
//            }
//        }
//    }
//}

//let handlers = videoId2CompletionHandlers[videoId, default: []]
//videoId2CompletionHandlers[videoId] = handlers + [completionHandler]
//if let data = videoId2Data[videoId] {
//    invokeCompletionHandlers(for: videoId, with: data)
//    return
//}
