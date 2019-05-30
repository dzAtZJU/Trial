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

class RippleVC: UIViewController,  StoreSubscriber {
    
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
    
    var inFocusCell: RippleCellV2 {
        return collectionView.cellForItem(at: layout.centerItem) as! RippleCellV2
    }
    
    var inFocusVideo: VideoWithPlayerView {
        return inFocusCell.videoWithPlayer!
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
        
        setupViews()
        
        collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .goToEpisodesView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .exitFullscreen, object: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        rippleViewStore.dispatch(RippleViewState.ReadyAction.ready)
        YoutubeManagers.shared.fetchVideoForItem(self.inFocusItem) { video, _ in
            self.inFocusCell.mountVideo(video)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rippleViewStore.unsubscribe(self)
    }
    
    func newState(state: RippleSceneState) {
        newStateForAnimation(state: state)
        
        collectionView.isDirectionalLockEnabled = state == .watching
        
        preSceneState = state
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
