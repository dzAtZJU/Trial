//
//  TestVC.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/10.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView

class TestVC: UIViewController {
    var videoView: WKWebView!
    
    var ytView: WKYTPlayerView
    
    override func viewDidLoad() {
        videoView = WKWebView(frame:  self.view.bounds)
        view.addSubview(videoView)
        videoView.load(URLRequest(url: URL(string: "https://www.youtube.com/watch?v=fl4EdD3cMQQ")!))
        
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(handleButton), for: .allEvents)
        view.addSubview(button)
    }
    
    @objc func handleButton() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 225, height: 143))
        let image = renderer.image { ctx in
            view.drawHierarchy(in: ctx.format.bounds, afterScreenUpdates: true)
        }
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        imageView.image = image
        view.addSubview(imageView)
    }
}

