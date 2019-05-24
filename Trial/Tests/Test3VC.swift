//
//  Test3VC.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/24.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class Test3VC: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    var content: UIView!
    
    override func viewDidLoad() {
        content = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 1000, height: 1000)))
        content.layer.borderColor = UIColor.red.cgColor
        content.layer.borderWidth = 10
        content.backgroundColor = UIColor.yellow
        scrollView.addSubview(content)
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0
        scrollView.maximumZoomScale = 10
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
//            self.scrollView.setZoomScale(0.3, animated: true)
            self.scrollView.zoom(to: CGRect(origin: .zero, size: CGSize(width: 1000, height: 1000)), animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return content
    }
}
