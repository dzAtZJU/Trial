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

var activityIndicator: UIActivityIndicatorView!

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
        let action = UIDevice.current.orientation.isPortrait ? RippleViewState.SceneAction.fullScreen : .stagedFullScreen
        rippleViewStore.dispatch(action)
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
        guard rippleViewStore.state.scene == .watching else {
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

// MARK: Animation
extension RippleVC {
    
    // Animation Category 1: Scene State change
    func newState(state: RippleSceneState) {
        executeAnimationByNewState = true
        
        switch state {
        case .watching, .surfing:
            runSceneAnimation()
        case .watching2Full:
            animationQueue.append {
                self.collectionView.collectionViewLayout = self.layout.nextOnStagedFull()
            }
            completionQueue.append {
                rippleViewStore.dispatch(RippleViewState.SceneAction.stagedFullScreen)
            }
        case .full:
            if UIDevice.current.orientation.isPortrait {
                executeAnimationByNewState = false
                UIDevice.current.triggerInterfaceRotate()
            }
            animationQueue.append {
                self.collectionView.collectionViewLayout = self.layout.nextOnFull()
            }
        default:
            fatalError()
        }
        
        if executeAnimationByNewState {
            runQueuedAnimatoin()
        }
    }
    
    func runQueuedAnimatoin() {
        if executeAnimationByNewState {
            UIView.animate(withDuration: 0.3, animations: {
                for animation in self.animationQueue {
                    animation()
                }
            }) { _ in
                for completion in self.completionQueue {
                    completion()
                }
            }
        }
    }
    
    // Animation Category 2: Orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
//        let (animation, completion) = doAnimationWhenRotate(layoutAnimation: getLayoutAnimationForRotate())
        if !executeAnimationByNewState {
            runQueuedAnimatoin()
        }
    }
    
//    func doAnimationWhenRotate(layoutAnimation: @escaping () -> ()) -> (() -> (), () -> ()) {
//        let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnRotate())
//        let animation = {
//            shadowAnimation()
//            layoutAnimation()
//            self.collectionView.visibleCells.forEach { cell in
//                cell.layoutIfNeeded()
//            }
//        }
//        let completion = {
//            shadowCompletion()
//            rippleViewStore.dispatch(RippleViewState.SceneAction.exitFullScreenCompleted)
//        }
//        return (animation, completion)
//    }
    
    
//    func getLayoutAnimationForRotate() -> () -> () {
//        switch rippleViewStore.state.scene {
//        case .full: // 竖屏状态下全屏 - 强制旋转
//            return {
//                self.collectionView.collectionViewLayout = self.layout.onFull()
//            }
//        case .full2Watching: // 竖屏状态下退出全屏 - 强制旋转
//            return {
//                self.collectionView.collectionViewLayout = self.layout.backFromFull()
//            }
//        default: // 用户旋转
//            return {
//                self.collectionView.collectionViewLayout = self.layout.nextOnRotate()
//            }
//        }
//    }
    
    // Animation: layout, cell, shadow
    // Completion: shadow, dispatch action
    
   
    
    func getCompletionForSceneTransit() -> () -> () {
        switch rippleViewStore.state.scene {
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
            animators = animators + self.inFocusCell!.addSceneTransitionAnimation(toScene: rippleViewStore.state.scene, duration: 0.3)
        }
        
        for animator in animators {
            animator.startAnimation()
        }
    }
    
//    func runExitFullScreenAnimation() {
//        if UIDevice.current.orientation.isPortrait {
//            UIDevice.current.triggerInterfaceRotate()
//        } else {
//            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
//            animator.addAnimations {
//                self.collectionView.collectionViewLayout = self.layout.backFromFull()
//            }
//            animator.addCompletion { _ in
//                rippleViewStore.dispatch(SceneAction.exitFullScreenCompleted)
//            }
//            animator.startAnimation()
//        }
//    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if rippleViewStore.state.scene == .full {
            return .landscapeRight
        } else {
            return .all
        }
    }
    
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
}


class RippleVC: UIViewController,  StoreSubscriber {
    
    var animationQueue = [() -> ()]()
    var completionQueue = [() -> ()]()
    var executeAnimationByNewState = true
    
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
        

        collectionView.collectionViewLayout = RippleTransitionLayout.genesisLayout
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
        rippleViewStore.subscribe(self) { subcription in
            subcription.select { appState in
                appState.scene
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rippleViewStore.unsubscribe(self)
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
        guard rippleViewStore.state.scene == .watching else {
            return
        }
        
        switch press.state {
            case .began:
                    inFocusCell?.handleUserLeave()
                    rippleViewStore.dispatch(RippleViewState.SceneAction.surf)
            default:
                return
        }
        return
    }
    
    // MARK: Miscellaneous
}
