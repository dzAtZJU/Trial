//
//  ViewController.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/12.
//  Copyright © 2019 周巍然. All rights reserved.
//

import UIKit
import Foundation
import YoutubePlayer_in_WKWebView

enum SceneState {
    case surfing
    case watching
    case initial
}

var sceneState = SceneState.initial

// MARK: CollectionViewDatasource
extension RippleVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCell
        cell.label.text = indexPath.description + "\(Int(cell.frame.midX)) \(Int(cell.frame.midY))"
        
//        YoutubeManagers.shared.getData(indexPath: indexPath) { youtubeVideoData in
//            DispatchQueue.main.async {
//                let videoId = youtubeVideoData.videoId!
//                cell.label.text = cell.label.text! + " \(videoId)"
//                if self.videoId2PlayerView[videoId] == nil {
//                    let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
//                    self.videoId2PlayerView[videoId] = player
//                }
//                cell.loadThumbnailImage(youtubeVideoData.thumbnail)
////                cell.embedYTPlayer(self.videoId2PlayerView[videoId]!)
//            }
//        }
        
        cell.positionId = indexPath
        return cell
    }
}

// MARK: CollectionViewDelegate
extension RippleVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sceneState {
        case .watching:
            let cell = collectionView.cellForItem(at: indexPath) as! RippleCell
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            self.present(vc, animated: true, completion: nil)
        case .surfing:
            collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
        default:
            return
        }
        
    }
}

// MARK: UIScrollViewDelegate
extension RippleVC {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layout.viewPortCenterChanged()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inFocusCell.pause()
        inFocusCell.updateScreenShot()
        inFocusCell.videoWithPlayer?.removeFromSuperview()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        YoutubeManagers.shared.getData(indexPath: layout.centerItem) { youtubeVideoData in
            DispatchQueue.main.async {
                let videoId = youtubeVideoData.videoId!
                if self.videoId2PlayerView[videoId] == nil {
                    let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
                    self.videoId2PlayerView[videoId] = player
                }
                self.inFocusCell.embedYTPlayer(self.videoId2PlayerView[videoId]!)
            }
        }
        inFocusCell.play()
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateSceneState()
    }
}

// MARK: Animation
extension RippleVC {
    var video: VideoWithPlayerView {
        return inFocusCell.videoWithPlayer
    }
}

class RippleVC: UICollectionViewController {
    var videoId2PlayerView = [VideoId: VideoWithPlayerView]()
    
    var rippleCollectionView: RippleCollectionView {
        get {
            return collectionView as! RippleCollectionView
        }
    }
    
    var inFocusCell: RippleCell {
        return collectionView.cellForItem(at: layout.lastCenterP) as! RippleCell
    }
    
    var layout: RippleTransitionLayout {
        return collectionView.collectionViewLayout as! RippleTransitionLayout
    }
    
    //MARK: Scene
    
    // MARK: VC
    override func viewDidLoad() {
        super.viewDidLoad()
        press = UILongPressGestureRecognizer(target: nil, action: nil)
        press!.addTarget(self, action: #selector(handlePress(_:)))
        collectionView.addGestureRecognizer(press!)
        collectionView.panGestureRecognizer.delegate = collectionView as! RippleCollectionView
        collectionView.isDirectionalLockEnabled = true
        updateSceneState()
        collectionView.scrollToItem(at: initialCenter1, at: [.centeredHorizontally, .centeredVertically], animated: false)
    }
    
    lazy var shadowWatch: CALayer = {
        let layer = CALayer()
        layer.contents = UIImage(named: "shadow_landing")?.cgImage
        return layer
    }()
    
    lazy var shadowSurf: CALayer = {
        let layer = CALayer()
        layer.contents = UIImage(named: "shadow_surfing")?.cgImage
        return layer
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        inFocusCell.play()
    }
    
    let indexPath2VideoId = [IndexPath: String]()
    
    func updateSceneState() {
        switch sceneState {
        case .surfing, .initial:
            shadowSurf.removeFromSuperlayer()
            view.layer.addSublayer(shadowWatch)
            shadowWatch.frame = view.layer.bounds
            if sceneState == .initial {
                collectionView.setCollectionViewLayout(RippleTransitionLayout.initialLayoutForWatch(centerLayout: initialLayout1), animated: false)
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.collectionView.collectionViewLayout = self.layout.getToggledLayout()
                    self.collectionView.visibleCells.forEach { cell in
                        cell.layoutIfNeeded()
                    }
                }
            }
            sceneState = .watching
            rippleCollectionView.sceneState = .watching
        case .watching:
            shadowWatch.removeFromSuperlayer()
            view.layer.addSublayer(shadowSurf)
            shadowSurf.frame = view.layer.bounds
            UIView.animate(withDuration: 0.5) {
                self.collectionView.collectionViewLayout = self.layout.getToggledLayout()
                self.collectionView.visibleCells.forEach { cell in
                    cell.layoutIfNeeded()
                }
            }
            sceneState = .surfing
            rippleCollectionView.sceneState = .surfing
        }
        collectionView.collectionViewLayout.addObserver(collectionView, forKeyPath: "lastCenterP", options: [.new, .old], context: nil)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Interaction
    var press: UILongPressGestureRecognizer?
    @objc func handlePress(_ press: UILongPressGestureRecognizer) {
        switch press.state {
        case .began:
                updateSceneState()
        default:
            print("press change")
            return
        }
        return
    }
    
    var transitionLayoutForWatching: UICollectionViewTransitionLayout?
    //    @objc func handlePanning(_ pan: UIPanGestureRecognizer) {
    //        switch pan.state {
    //            case .began:
    //                if let layoutForWatching = layoutForWatching {
    //                    let direction = Direction.fromVelocity(pan.velocity(in: collectionView))
    //                    (collectionView as! RippleCollectionView).transitionDirection = direction
    //                    transitionLayoutForWatching = collectionView.startInteractiveTransition(to: layoutForWatching.nextLayoutOn(direction: direction), completion: nil)
    //                }
    //            case .changed:
    //                let timing = timingFromPanningTranslation(pan.translation(in: collectionView))
    //                transitionLayoutForWatching?.transitionProgress = timing
    //            case .ended:
    //                collectionView.finishInteractiveTransition()
    //            default:
    //                return
    //            }
    //    }
}

