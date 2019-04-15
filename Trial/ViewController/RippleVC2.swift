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

var activityIndicator: UIActivityIndicatorView!
var sceneState = SceneState.initial

// MARK: CollectionViewDatasource
extension RippleVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    /// Configure global cell contents, that is, each cell has such contents
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCell
        cell.label.text = indexPath.description + "\(Int(cell.frame.midX)) \(Int(cell.frame.midY))"
        cell.positionId = indexPath
        
        YoutubeManagers.shared.getData(indexPath: indexPath) { youtubeVideoData in
            DispatchQueue.main.async {
                guard cell.positionId == indexPath else {
                    return
                }
                
                let videoId = youtubeVideoData.videoId!
                cell.label.text = cell.label.text! + " \(videoId)"
                cell.loadThumbnailImage(youtubeVideoData.thumbnail)
            }
        }
        
        return cell
    }
}

//if self.videoId2PlayerView[videoId] == nil {
//    let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
//    self.videoId2PlayerView[videoId] = player
//}

// MARK: CollectionViewDelegate
extension RippleVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sceneState {
        case .watching:
            let cell = collectionView.cellForItem(at: indexPath) as! RippleCell
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            self.present(vc, animated: true, completion: nil)
        case .surfing:
            updateSceneState(moveTo: indexPath)
            collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
//            if indexPath == layout.centerItem {
//                updateSceneState()
//            } else {
//                collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
//            }
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
        inFocusCell?.handleUserLeave()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard sceneState == .watching else {
            return
        }
        
        /// TODO: where to maintain centerItem
        YoutubeManagers.shared.getData(indexPath: layout.centerItem) { youtubeVideoData in
            DispatchQueue.main.async {
                let videoId = youtubeVideoData.videoId!
                if self.videoId2PlayerView[videoId] == nil {
                    let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
                    self.videoId2PlayerView[videoId] = player
                }
                self.inFocusCell?.handleUserEnter(video: self.videoId2PlayerView[videoId]!)
            }
        }
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        updateSceneState()
    }
}

// MARK: Animation
extension RippleVC {
    var video: VideoWithPlayerView {
        return inFocusCell!.videoWithPlayer!
    }
}

class RippleVC: UICollectionViewController {
    var videoId2PlayerView = [VideoId: VideoWithPlayerView]()
    
    var rippleCollectionView: RippleCollectionView {
        get {
            return collectionView as! RippleCollectionView
        }
    }
    
    var inFocusCell: RippleCell? {
        return collectionView.cellForItem(at: layout.centerItem) as? RippleCell
    }
    
    var layout: RippleTransitionLayout {
        return collectionView.collectionViewLayout as! RippleTransitionLayout
    }
    
    //MARK: Scene
    
    // MARK: VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        collectionView.addGestureRecognizer(press!)
        
        updateSceneState()
        collectionView.scrollToItem(at: initialCenter1, at: [.centeredHorizontally, .centeredVertically], animated: false)
        YoutubeManagers.shared.getData(indexPath: layout.centerItem) { youtubeVideoData in
            DispatchQueue.main.async {
                let videoId = youtubeVideoData.videoId!
                if self.videoId2PlayerView[videoId] == nil {
                    let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
                    self.videoId2PlayerView[videoId] = player
                }
                self.inFocusCell?.handleUserEnter(video: self.videoId2PlayerView[videoId]!)
            }
        }
    }
    
    func setupViews() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
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
        inFocusCell?.play()
    }
    
    let indexPath2VideoId = [IndexPath: String]()
    
    /// User wants to transfer scene
    func updateSceneState(moveTo: IndexPath? = nil) {
        switch sceneState {
        case .surfing, .initial:
            shadowSurf.removeFromSuperlayer()
            view.layer.addSublayer(shadowWatch)
            shadowWatch.frame = view.layer.bounds
            if sceneState == .initial {
                collectionView.setCollectionViewLayout(RippleTransitionLayout.initialLayoutForWatch(centerLayout: initialLayout1), animated: false)
            } else {
                
                var animators = [UIViewPropertyAnimator]()
                let layoutAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
                layoutAnimator.addAnimations {
                    self.collectionView.collectionViewLayout = self.layout.getToggledLayout(moveTo: moveTo)
                    self.collectionView.visibleCells.forEach { cell in
                        cell.layoutIfNeeded()
                    }
                }
                layoutAnimator.addCompletion { (_) in
                    YoutubeManagers.shared.getData(indexPath: self.layout.centerItem) { youtubeVideoData in
                        DispatchQueue.main.async {
                            let videoId = youtubeVideoData.videoId!
                            if self.videoId2PlayerView[videoId] == nil {
                                let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
                                self.videoId2PlayerView[videoId] = player
                            }
                            self.inFocusCell?.handleUserEnter(video: self.videoId2PlayerView[videoId]!)
                        }
                    }
                }
                animators.append(layoutAnimator)
                
                animators = animators + self.inFocusCell!.addSceneTransitionAnimation(toScene: .watching, duration: 0.3)
                for animator in animators {
                    animator.startAnimation()
                }
            }
            sceneState = .watching
            rippleCollectionView.sceneState = .watching
        case .watching:
            shadowWatch.removeFromSuperlayer()
            view.layer.addSublayer(shadowSurf)
            shadowSurf.frame = view.layer.bounds
            
            var animators = [UIViewPropertyAnimator]()

            let layoutAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
            layoutAnimator.addAnimations {
                self.collectionView.collectionViewLayout = self.layout.getToggledLayout(moveTo: moveTo)
                self.collectionView.visibleCells.forEach { cell in
                    cell.layoutIfNeeded()
                }
            }
            layoutAnimator.addCompletion { _ in
                print(self.layout)
            }
            animators.append(layoutAnimator)

            animators = animators + self.inFocusCell!.addSceneTransitionAnimation(toScene: .surfing, duration: 0.3)

            for animator in animators {
                animator.startAnimation()
            }
            
            
            sceneState = .surfing
            rippleCollectionView.sceneState = .surfing
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Interaction
    var press: UILongPressGestureRecognizer?
    @objc func handlePress(_ press: UILongPressGestureRecognizer) {
        guard sceneState == .watching else {
            return
        }
        
        switch press.state {
            case .began:
                    inFocusCell?.handleUserLeave()
                    updateSceneState()
            default:
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

