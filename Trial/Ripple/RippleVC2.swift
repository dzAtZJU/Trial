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
import ReSwift

enum SceneState: StateType {
    case surfing
    case full
    case initial
    case surf2Watching
    case full2Watching
    case initial2Watching
    case watching
    
}

var activityIndicator: UIActivityIndicatorView!
var sceneState = SceneState.initial

extension RippleVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ytRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytCols
    }
    
    /// Configure global cell contents, that is, each cell has such contents
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

extension RippleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if store.state.scene == .full {
            closVideo()
            return
        }
        
        store.dispatch(SceneAction.touchCell)
//        updateSceneState(moveTo: indexPath)
//        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
        
    }
    
    func closVideo() {
        store.dispatch(SceneAction.exitFullScreen)
    }
}

extension RippleVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layout.viewPortCenterChanged()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inFocusCell?.handleUserLeave()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
}

// MARK: Rotation
extension RippleVC {
    
    func installShadow(_ newShadow: Shadow) -> (() -> Void, () -> Void) {
        newShadow.frame = view.bounds
        newShadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newShadow.alpha = 0
        view.addSubview(newShadow)
        
        return ({ self.shadow.alpha = 0
            newShadow.alpha = 1
        }, {
            self.shadow.removeFromSuperview()
            self.shadow = newShadow
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let (animation, completion) = assembleAnimationForRotate(layoutAnimation: getLayoutAnimationForRotate())
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
            animation()
        }) { _ in
            completion()
        }
    }
    
    func newState(state: SceneState) {
        switch state {
        case .full:
            runFullScreenAnimatoin()
        case .full2Watching:
            runExitFullScreenAnimation()
        case .surfing:
            runSceneAnimation()
        case .surf2Watching:
            return
        case .watching:
            runSceneAnimation()
        case .initial:
            runSceneAnimation()
        default:
            return
        }
    }
    
    func runSceneAnimation(moveTo: IndexPath? = nil) {
        // Shadow
        let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnScene())
        shadow.frame = view.bounds
        
        var animators = [UIViewPropertyAnimator]()
        
        // Layout
        let layoutAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        layoutAnimator.addAnimations {
            self.collectionView.collectionViewLayout = self.layout.nextOnScene().nextOnMove(moveTo)
            self.collectionView.visibleCells.forEach { cell in
                cell.layoutIfNeeded()
            }
            shadowAnimation()
        }
        layoutAnimator.addCompletion { (_) in
            self.getCompletionForSceneTransit()()
            shadowCompletion()
        }
        animators.append(layoutAnimator)
        
        // Cell
        if self.inFocusCell != nil {
            animators = animators + self.inFocusCell!.addSceneTransitionAnimation(toScene: store.state.scene, duration: 0.3)
        }
        
        for animator in animators {
            animator.startAnimation()
        }
    }
    
    func setupScene() {
        collectionView.setCollectionViewLayout(RippleTransitionLayout.initialLayoutForWatch(centerLayout: initialLayout1), animated: false)
    }
    
    func getCompletionForSceneTransit() -> () -> () {
        switch store.state.scene {
            case .watching:
                return {
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
            case .surfing:
                return {}
            default:
                return {}
        }
    }
    
    func getLayoutAnimationForRotate() -> () -> () {
        //        defer {
        //            isForceRotated = false
        //        }
        //
        //        if isForceRotated {
        //            return {
        //                self.collectionView.collectionViewLayout = self.layout.onFull()
        //            }
        //        }
        
        switch store.state.scene {
        case .full:
            return {
                self.collectionView.collectionViewLayout = self.layout.onFull()
            }
        case .full2Watching:
            return {
                self.collectionView.collectionViewLayout = self.layout.backFromFull()
            }
        default:
            return {
                self.collectionView.collectionViewLayout = self.layout.nextOnRotate()
            }
        }
    }
    
    func assembleAnimationForRotate(layoutAnimation: @escaping () -> ()) -> (() -> (), () -> ()) {
        let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnRotate())
        let animation = {
            shadowAnimation()
            layoutAnimation()
            self.collectionView.visibleCells.forEach { cell in
                cell.layoutIfNeeded()
            }
        }
        let completion = {
            shadowCompletion()
            store.dispatch(SceneAction.exitFullScreenCompleted)
        }
        return (animation, completion)
    }
    
    func runExitFullScreenAnimation() {
        if UIDevice.current.orientation.isPortrait {
            UIDevice.current.triggerInterfaceRotate()
        } else {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
            animator.addAnimations {
                self.collectionView.collectionViewLayout = self.layout.backFromFull()
            }
            animator.addCompletion { _ in
                store.dispatch(SceneAction.exitFullScreenCompleted)
            }
            animator.startAnimation()
        }
    }
    
    func runFullScreenAnimatoin() {
        isForceRotated = true
        
        if UIDevice.current.orientation.isPortrait {
            UIDevice.current.triggerInterfaceRotate()
        } else {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
            let (animation, completion) = assembleAnimationForRotate(layoutAnimation: getLayoutAnimationForRotate())
            animator.addAnimations {
                animation()
            }
            animator.addCompletion { _ in
                completion()
            }
            animator.startAnimation()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if store.state.scene == .full {
            return .landscapeRight
        } else {
            return .all
        }
    }
    
}


class RippleVC: UIViewController,  StoreSubscriber {
    private var isForceRotated = false
    
    var shadow = Shadow.dumb
    
    var videoId2PlayerView = [VideoId: VideoWithPlayerView]()
    
    @IBOutlet weak var collectionView: RippleCollectionView!
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupViews()
        
        press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        collectionView.addGestureRecognizer(press!)
        
//        updateSceneState()
        setupScene()
        
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
        
        NotificationCenter.default.addObserver(forName: .goToEpisodesView, object: nil, queue: nil) { notification in
            let episodesVC = EpisodesVC()
            self.present(episodesVC, animated: false, completion: nil)
        }
    }
    
    func setupViews() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0),
                                     NSLayoutConstraint(item: self.view, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) { subcription in
            subcription.select { appState in
                appState.scene
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inFocusCell?.play()
    }
    
    let indexPath2VideoId = [IndexPath: String]()
    
    /// User wants to transfer scene
    func updateSceneState(moveTo: IndexPath? = nil) {
//        switch sceneState {
//        case .surfing, .initial:
//            let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnScene())
//            shadow.frame = view.bounds
//            if sceneState == .initial {
//                collectionView.setCollectionViewLayout(RippleTransitionLayout.initialLayoutForWatch(centerLayout: initialLayout1), animated: false)
//                shadowAnimation()
//                shadowCompletion()
//            } else {
//
//                var animators = [UIViewPropertyAnimator]()
//                let layoutAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
//                layoutAnimator.addAnimations {
//                    self.collectionView.collectionViewLayout = self.layout.nextOnScene().nextOnMove(moveTo)
//                    self.collectionView.visibleCells.forEach { cell in
//                        cell.layoutIfNeeded()
//                    }
//                    shadowAnimation()
//                }
//                layoutAnimator.addCompletion { (_) in
//                    YoutubeManagers.shared.getData(indexPath: self.layout.centerItem) { youtubeVideoData in
//                        DispatchQueue.main.async {
//                            let videoId = youtubeVideoData.videoId!
//                            if self.videoId2PlayerView[videoId] == nil {
//                                let player = VideoWithPlayerView.loadVideoForWatch(videoId: videoId)
//                                self.videoId2PlayerView[videoId] = player
//                            }
//                            self.inFocusCell?.handleUserEnter(video: self.videoId2PlayerView[videoId]!)
//                        }
//                    }
//                    shadowCompletion()
//                }
//                animators.append(layoutAnimator)
//
//                animators = animators + self.inFocusCell!.addSceneTransitionAnimation(toScene: .watching, duration: 0.3)
//                for animator in animators {
//                    animator.startAnimation()
//                }
//            }
//            sceneState = .watching
//            store.state.scene = .watching
//            collectionView.sceneState = .watching
//        case .watching:
//            let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnScene())
//            shadow.frame = view.bounds
//
//            var animators = [UIViewPropertyAnimator]()
//
//            let layoutAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
//            layoutAnimator.addAnimations {
//                self.collectionView.collectionViewLayout = self.layout.nextOnScene()
//                self.collectionView.visibleCells.forEach { cell in
//                    cell.layoutIfNeeded()
//                }
//                shadowAnimation()
//            }
//            layoutAnimator.addCompletion { _ in
//                shadowCompletion()
//            }
//            animators.append(layoutAnimator)
//
//            animators = animators + self.inFocusCell!.addSceneTransitionAnimation(toScene: .surfing, duration: 0.3)
//
//            for animator in animators {
//                animator.startAnimation()
//            }
//
//            sceneState = .surfing
//            collectionView.sceneState = .surfing
//        default:
//            return
//        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Interaction
    var press: UILongPressGestureRecognizer?
    @objc func handlePress(_ press: UILongPressGestureRecognizer) {
        store.dispatch(SceneAction.press)
        guard sceneState == .watching else {
            return
        }
        
        switch press.state {
            case .began:
                    inFocusCell?.handleUserLeave()
//                    updateSceneState()
            default:
                return
        }
        return
    }
    
    // MARK: Miscellaneous
}
