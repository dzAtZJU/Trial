//
//  YoutubeManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/19.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import youtube_ios_player_helper

class YoutubeManager {
    
    static let shared = YoutubeManager()
    
    var videoIds = [IndexPath:String]()
    
    var videos = [IndexPath:YTPlayerView]()
    
    func loadVideoIds() {
        for row in 0..<ytRows {
            for col in 0..<ytCols {
                videoIds[IndexPath(row: col, section: row)] = "_uk4KXP8Gzw"
            }
        }
    }
    
    func loadVideos() {
        for row in 0..<ytRows {
            for col in 0..<ytCols {
                let playerVideo = YTPlayerView(frame: CGRect.zero)
                let indexPath = IndexPath(row: col, section: row)
                let videoId = videoIds[indexPath]!
                playerVideo.load(withVideoId: videoId, playerVars: ["controls":0, "playsinline":1])
                videos[indexPath] = playerVideo
            }
        }
    }
}
