////
////  ViewController.swift
////  Trial
////
////  Created by 周巍然 on 2019/3/12.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import UIKit
//import youtube_ios_player_helper
//
//func positionFromIndex(_ index: IndexPath) -> CGPoint {
//    return CGPoint(x:CGFloat(index.section) * itemWidth, y: CGFloat(index.row) * itemHeight)
//}
//enum SceneState {
//    case surfing
//    case watching
//    case initial
//}
//
//// MARK: CollectionViewDatasource
//extension RippleVC {
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return ytRows
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ytCols
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RippleCell
//        cell.label.text = indexPath.description + "\(cell.frame.midX) \(cell.frame.midY)"
//        YoutubeManagers.shared.getData(indexPath: indexPath) { youtubeVideoData in
//            DispatchQueue.main.async {
//                let videoId = youtubeVideoData.videoId!
//                if self.videoId2PlayerView[videoId] == nil {
//                    let player = VideoWithPlayerView.createForInitialWatch(videoId: videoId)
//                    player.videoView.load(withVideoId: videoId, playerVars: ["controls":0, "playsinline":1])
//                    player.videoView.fixWebViewLayout()
//                    self.videoId2PlayerView[videoId] = player
//                }
//                cell.configure(with: youtubeVideoData, playerView: self.videoId2PlayerView[videoId]!)
//            }
//        }
//        return cell
//    }
//}
//
//// MARK: CollectionViewDelegate
//extension RippleVC {
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! RippleCell
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
//        self.present(vc, animated: true, completion: nil)
//    }
//}
//
//class RippleVC: UICollectionViewController {
//    var videoId2PlayerView = [VideoId: VideoWithPlayerView]()
//
//    // MARK: VC
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        press = UILongPressGestureRecognizer(target: nil, action: nil)
//        press!.addTarget(self, action: #selector(handlePress(_:)))
//        collectionView.addGestureRecognizer(press!)
//        collectionView.panGestureRecognizer.delegate = collectionView as! RippleCollectionView
//
//        updateSceneState()
//        collectionView.scrollToItem(at: initialCenter1, at: [.centeredHorizontally, .centeredVertically], animated: false)
//    }
//
//    let indexPath2VideoId = [IndexPath: String]()
//
//    var cellInFocus: RippleCell {
//        return collectionView.cellForItem(at: layoutForWatching!.centerItem) as! RippleCell
//    }
//
//    var sceneState: SceneState = .initial
//    func updateSceneState() {
//        switch sceneState {
//            case .surfing, .initial:
//                if sceneState == .initial {
//                    collectionView.setCollectionViewLayout(RippleTransitionLayout.initialLayoutForWatch(centerLayout: initialLayout1), animated: false)
//                } else {
////                    let centerItem = layoutForSurfing!.centerItem
////                    let newLayout = RippleTransitionLayout.nextLayoutForWatch(center: centerItem, centerPosition: initialLayout1.centerOf(centerItem))
////                    collectionView.setCollectionViewLayout(newLayout, animated: false)
//                    layoutForSurfing?.toggleTemplatFor(scene: .watching)
//                    collectionView.scrollToItem(at: layoutForWatching!.centerItem, at: [.centeredVertically, .centeredHorizontally], animated: true)
//                }
//                sceneState = .watching
//                rippleCollectionView.sceneState = .watching
//            case .watching:
////                let centerItem = layoutForWatching!.centerItem
////                collectionView.setCollectionViewLayout(RippleTransitionLayout.nextLayoutForSurf(center: centerItem, centerPosition: initialLayout1ForSurf.centerOf(centerItem)), animated: false)
//                layoutForWatching?.toggleTemplatFor(scene: .surfing)
//                sceneState = .surfing
//                rippleCollectionView.sceneState = .surfing
//            }
//        collectionView.collectionViewLayout.addObserver(collectionView, forKeyPath: "lastCenterP", options: [.new, .old], context: nil)
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//    // MARK: Interaction
//    var press: UILongPressGestureRecognizer?
//    @objc func handlePress(_ press: UILongPressGestureRecognizer) {
//        switch press.state {
//        case .began, .ended:
//            if layoutForWatching != nil || layoutForSurfing != nil {
//                updateSceneState()
//            }
//        default:
//            print("press change")
//            return
//        }
//        return
//    }
//
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let viewCenter = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
//        layoutForSurfing?.viewCenterChanged(viewCenter)
//        layoutForWatching?.viewCenterChanged(viewCenter)
//    }
//
//    var transitionLayoutForWatching: UICollectionViewTransitionLayout?
//    //    @objc func handlePanning(_ pan: UIPanGestureRecognizer) {
//    //        switch pan.state {
//    //            case .began:
//    //                if let layoutForWatching = layoutForWatching {
//    //                    let direction = Direction.fromVelocity(pan.velocity(in: collectionView))
//    //                    (collectionView as! RippleCollectionView).transitionDirection = direction
//    //                    transitionLayoutForWatching = collectionView.startInteractiveTransition(to: layoutForWatching.nextLayoutOn(direction: direction), completion: nil)
//    //                }
//    //            case .changed:
//    //                let timing = timingFromPanningTranslation(pan.translation(in: collectionView))
//    //                transitionLayoutForWatching?.transitionProgress = timing
//    //            case .ended:
//    //                collectionView.finishInteractiveTransition()
//    //            default:
//    //                return
//    //            }
//    //    }
//
//    func timingFromPanningTranslation(_ translation: CGPoint) -> CGFloat {
//        let distance = hypot(translation.x, translation.y)
//        return min(distance / (itemWidthForWatching / 2), 1)
//    }
//
//    var layoutForWatching: RippleTransitionLayout? {
//        return collectionView.collectionViewLayout as? RippleTransitionLayout
//    }
//
//    var layoutForSurfing: RippleTransitionLayout? {
//        return collectionView.collectionViewLayout as? RippleTransitionLayout
//    }
//
//    var rippleCollectionView: RippleCollectionView {
//        get {
//            return collectionView as! RippleCollectionView
//        }
//    }
//}
//
