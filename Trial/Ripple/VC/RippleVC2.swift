
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

class RippleVC: UIViewController,  StoreSubscriber {
    
    var dataManager: RippleDataManager!
    
    var animationQueue = [() -> ()]()
    var completionQueue = [() -> ()]()
    var executeAnimationByNewState = true
    
    var preSceneState = RippleSceneState.surfing
    
    var shadow = Shadow.dumb
    
    @IBOutlet weak var collectionView: RippleCollectionView!
    
    var press: UILongPressGestureRecognizer?
    
    let indexPath2VideoId = [IndexPath: String]()
    
    var selectedItem: IndexPath!
    
    var lockScrollUpdate = false
    
    var inFocusItem: IndexPath {
        return layout.centerItem
    }
    
    var inFocusCell: RippleCellV2! {
        return collectionView.cellForItem(at: layout.centerItem) as? RippleCellV2
    }
    
    var layout: RippleTransitionLayout {
        return collectionView.collectionViewLayout as! RippleTransitionLayout
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.collectionViewLayout = RippleTransitionLayout.genesisLayout
        updateContentInset()
        collectionView.scrollToItem(at: initialCenter1, at: [.centeredHorizontally, .centeredVertically], animated: false)
        
        collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:))))
        
        prepareForePresent()
        
        rippleViewStore.subscribe(self) { subcription in
            subcription.select { appState in
                appState.scene
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification), name: .rippleItemChange, object: nil)
    }

    func prepareForePresent() {
        try! RippleDataManager.load(userId: "") {
            self.dataManager = $0
        }
    }
    
    func prepareForReAppear() {
        if transferVideoId != nil {
            dataManager.setVideoId(at: inFocusItem, videoId: transferVideoId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .goToEpisodesView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .exitFullscreen, object: nil)
        
        super.viewWillAppear(animated)
        
        dataManager.fetchVideo(inFocusItem) { (video, _) in
            FullscreenVideoManager.current.gotoWindow(video: video, window: self.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rippleViewStore.dispatch(RippleViewState.ReadyAction.ready)
        dataManager.fetchVideo(inFocusItem) { (video, _) in
            FullscreenVideoManager.current.gotoCell()
            self.inFocusCell.mountVideo(video)
            rippleViewStore.dispatch(RippleViewState.SceneAction.fullScreen)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .goToEpisodesView, object: nil)
        NotificationCenter.default.removeObserver(self, name: .exitFullscreen, object: nil)
    }
    
    func newState(state: RippleSceneState) {
        newStateForAnimation(state: state)
        
        collectionView.isDirectionalLockEnabled = state == .watching
        
        collectionView.isScrollEnabled = state != .full
        
        dataManager.fetchVideo(inFocusItem) { (video, _) in
            video.isUserInteractionEnabled = state == .full
        }
        
        preSceneState = state
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
