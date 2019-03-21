//
//  YTPlayerView.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/20.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import WebKit

    
func createYTPlayerView(videoId: String) -> WKWebView {
    let webConfiguration = WKWebViewConfiguration()
    let webView = WKWebView(frame: .zero, configuration: webConfiguration)
    
    
    
    return webView
}
