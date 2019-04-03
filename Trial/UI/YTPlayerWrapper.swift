//
//  YTPlayerWrapper.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import YoutubePlayer_in_WKWebView

 protocol YTPlayerWrapper {
    func embedYTPlayer(_ newPlayerView: WKYTPlayerView)
}
