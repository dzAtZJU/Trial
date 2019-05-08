////
////  TestVC.swift
////  Trial
////
////  Created by 周巍然 on 2019/5/8.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import Foundation
//import UIKit
//import WebKit
//import CoreGraphics
//
//class TestVC: UIViewController {
//    var web: WKWebView!
//    var aView: UIView!
//
//    var link: CADisplayLink!
//
//    @IBAction func onClick(_ sender: Any) {
//        link = CADisplayLink(target: self, selector: #)
//
//    }
//
//    @IBAction func onBackClick(_ sender: Any) {
//
//    }
//
//    //        UIView.animate(withDuration: 1) {
//    //            self.web.layer.bounds.size = self.web.bounds.size + CGSize(width: 100, height: 100)
//    //        }
//
//    func install() {
//
//    }
//
//    func unInstall() {
//
//    }
//
//    override func viewDidLoad() {
//        view.backgroundColor = UIColor.yellow
//
//        aView = UIView()
//        aView.translatesAutoresizingMaskIntoConstraints = false
//        aView.backgroundColor = UIColor.red
//        aView.frame = CGRect(origin: CGPoint(x: 10, y: 400), size: CGSize(width: 300, height: 200))
//        view.addSubview(aView)
//
//        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.allowsInlineMediaPlayback = true
//        web = WKWebView(frame: .zero, configuration: webConfiguration)
//        web.translatesAutoresizingMaskIntoConstraints = false
//        web.backgroundColor = UIColor.blue
//        web.frame = CGRect(origin: CGPoint(x: 10, y: 0), size: CGSize(width: 300, height: 200))
//        view.addSubview(web)
//        web.load(URLRequest(url: URL(string: "https://www.youtube.com/watch?v=FTRj0QZ8UVw")!))
//
//
//
////        perform(#selector(animate), with: nil, afterDelay: 5)
////        let theVideo = self.inFocusCell!.videoWithPlayer!.videoView
////        theVideo.frame = CGRect(origin: .zero, size: CGSize(width: 300, height: 300))
////        theVideo.translatesAutoresizingMaskIntoConstraints = false
////        view.window?.addSubview(theVideo)
////
////        let s = f ? -200 : 200
////
////        let bounds = theVideo.layer.bounds + CGRect(origin: .zero, size: CGSize(width: s, height: 0))
////        theVideo.layer.bounds = bounds
////        print(bounds)
////        print(theVideo.frame)
////        f = !f
//    }
//}
