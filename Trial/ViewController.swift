//
//  ViewController.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

protocol AnimationExpanding {
    var initialFrame: CGRect {
        get
    }
}

extension ViewController: AnimationExpanding {
    var initialFrame: CGRect {
        if let centerItem = self.layout.centerItem, let cell = collectionView.cellForItem(at: centerItem) {
            return collectionView.convert(cell.frame, to: nil)
        }
        return CGRect.zero
    }
}

enum SceneState {
    case one
    case two
}


class ViewController: UICollectionViewController {
    
    var videoIds = [IndexPath:String]()
    var playerViews = [IndexPath:YTPlayerView]()
    
    var sceneState: SceneState = .one
    
    // MARK: CollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sceneState {
            case .one:
                collectionView.setCollectionViewLayout(CollectionViewLayout.scene1To2(scale: 1), animated: true)
                collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
                scrollViewDidScroll(collectionView)
                collectionView.panGestureRecognizer.addTarget(self, action: #selector(handlePanning(_:)))
                sceneState = .two
            case .two:
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController")
                    self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    // MARK: CollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.setPlayerView(YoutubeManager.shared.videos[indexPath]!)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for section in 0..<numberOfSections(in: collectionView) {
            for row in 0..<collectionView(collectionView, numberOfItemsInSection: section) {
                videoIds[IndexPath(row: row, section: section)] = "_uk4KXP8Gzw"
            }
        }
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinch)
    }
    
    var pinch: UIPinchGestureRecognizer!
    
    @objc func handlePinch(_ recognizer: UIGestureRecognizer) {
        if sceneState == .two {
            sceneState = .one
            collectionView.setCollectionViewLayout(CollectionViewLayout.scene1(), animated: false)
            collectionView.panGestureRecognizer.removeTarget(self, action: #selector(handlePanning(_:)))
            scrollViewDidScroll(collectionView)
        }
    }
    
    @objc func handlePanning(_ recognizer: UIGestureRecognizer) {
        if let recognizer = recognizer as? UIPanGestureRecognizer {
            if recognizer.state == .ended, let currentCentralItem = layout.centerItem {
                var nextItem: IndexPath
                let v = recognizer.velocity(in: collectionView)
                if hypot(v.x, v.y) > velocityThreshold {
                    let direction = Direction.fromVelocity(v)
                    nextItem = layout.nextItemOnDirection(direction)
                } else {
                     nextItem = currentCentralItem
                }
                collectionView.scrollToItem(at: nextItem, at: [.centeredVertically, .centeredHorizontally], animated: true)
            }
        }
    }
    
    var layout: CollectionViewLayout {
        return collectionView.collectionViewLayout as! CollectionViewLayout
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
        layout.updateCenter(center)
    }
    
    var currentCentralItem: IndexPath?
    var lastCentralItem: IndexPath?
    var currentCenterDistance: Float = 0
    var currentCentralCell: UICollectionViewCell? {
        guard currentCentralItem != nil else {
            return nil
        }
        return collectionView.cellForItem(at: currentCentralItem!)
    }
    var lastCentralCell: UICollectionViewCell? {
        guard lastCentralItem != nil else {
            return nil
        }
        return collectionView.cellForItem(at: lastCentralItem!)
    }
}

