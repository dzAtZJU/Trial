//
//  YoutubeManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/19.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import YoutubePlayer_in_WKWebView
import GoogleAPIClientForREST
import GoogleSignIn

//class YoutubeManager {
//    func getData(indexPath: IndexPath, completion: @escaping (YoutubeVideoData?) -> Void) {
//        let videoId = videoIds[indexPath]!
//        let thumbnailUrl = thumbnailUrls[videoId]!
////        asynFether.fetchAsync(thumbnailUrl, completion: completion)
//        let thumbnail = thumbnails[thumbnailUrl]
//        completion(YoutubeVideoData(thumbnail: thumbnail!))
//    }
//
//    let asynFether = AsyncFetcher()
//
//
//    var videoIds = [IndexPath: VideoId]()
//
//    var videoIdsArray: [String] {
//        return Array(videoIds.values)
//    }
//
//    var thumbnailUrls = [VideoId: URLString]()
//
//    var thumbnails = [URLString: UIImage]()
//
//
//    static let shared = YoutubeManager()
//
//    var videos = [IndexPath:YTPlayerView]()
//
//
//    func thumbNailFor(_ indexPath: IndexPath) -> String? {
//        return thumbnailUrls[videoIds[indexPath]!]
//    }
//
//    func loadVideoIds() {
//        for row in 0..<ytRows {
//            for col in 0..<ytCols {
//                videoIds[IndexPath(row: col, section: row)] = "_uk4KXP8Gzw"
//            }
//        }
//        fetchThumbNailUrls(videoIds: Array(videoIds.values))
//    }
//
//    func loadVideos() {
//        for row in 0..<ytRows {
//            for col in 0..<ytCols {
//                let playerVideo = YTPlayerView(frame: CGRect.zero)
//                let indexPath = IndexPath(row: col, section: row)
//                let videoId = videoIds[indexPath]!
//                playerVideo.load(withVideoId: videoId, playerVars: ["controls":0, "playsinline":1])
//                videos[indexPath] = playerVideo
//            }
//        }
//    }
//
//    let service: GTLRYouTubeService = {
//        let s = GTLRYouTubeService()
//        s.apiKey = "AIzaSyCdC0q9pnE9t5uB9klpdaf_P7PICftusv0"
//        return s
//    }()
//    let query = GTLRYouTubeQuery_VideosList.query(withPart: "snippet")
//
//
//    func fetchThumbNailUrls(videoIds: [String]) {
//        query.identifier = videoIds.joined(separator: ",")
//        service.executeQuery(query) { (ticket, response, error) in
//            let response = response as! GTLRYouTube_VideoListResponse
//            if let items = response.items {
//                for item in items {
//                    if let identifier = item.identifier, let url = item.snippet?.thumbnails?.high?.url {
//                        self.thumbnailUrls[identifier] = url
//                        self.fetchThumbnail(url, completion: nil)
//                    }
//                }
//            }
//        }
//    }
//
//    func fetchThumbnail(_ url: String, completion: ((UIImage) -> Void)?) {
//        DispatchQueue.global().async {
//            if let data = try? Data(contentsOf: URL(string: url)!) {
//                self.thumbnails[url] = UIImage(data: data)!
//                if let completion = completion {
//                    completion(self.thumbnails[url]!)
//                }
//            }
//        }
//    }
//
//    func fetchThumbnail(_ indexPath: IndexPath, completion: @escaping ((UIImage) -> Void)) {
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
//            if let identifier = self.videoIds[indexPath], let url = self.thumbnailUrls[identifier] {
//                if let thumbnail = self.thumbnails[url] {
//                    completion(thumbnail)
//                } else {
//                    self.fetchThumbnail(url, completion: { completion($0) })
//                }
//            }
//        }
//    }
//}
