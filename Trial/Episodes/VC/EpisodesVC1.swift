//
//  EpisodesVC.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

let episodesViewHorizontalExtent: CGFloat = 100

struct EpisodesVCModel {
    var pageDataManager: EpisodesDataManager
    
    let viewStore: Store<EpisodesViewState>
    
    var latestWatchItem: IndexPath
    
    mutating func setLatestWatchItem(_ item: IndexPath) {
        latestWatchItem = item
    }
}

class EpisodesVC: UIViewController {
    
    static let shared = EpisodesVC()
    
    // Views
    var thumbnailBg: UIImageView!
    
    var thumbnailBlur: UIVisualEffectView!
    
    var thumbnailShadow: UIImageView!
    
    var seasonMaskWindow: UIView!
    
    var seasonsView: UICollectionView!
    
    var episodesView: EpisodesView!
    
    var shadowLeft: UIImageView!
    
    var shadowRight: UIImageView!
    
    var lastWatchButton: UIButton!
    
    var model: EpisodesVCModel!
    
    var autoScrollFlag = false
    
    var layout: EpisodesLayout {
        return episodesView.collectionViewLayout as! EpisodesLayout
    }
    
    // Layout Alternate
    
    var preSceneState: EpisodesSceneState? = nil
    
    // States
    var centerItem: IndexPath! = IndexPath(row: 0, section: 0) {
        didSet {
            (episodesView.cellForItem(at: oldValue) as? EpisodeCell)?.isHighlighted = false
            (episodesView.cellForItem(at: centerItem) as? EpisodeCell)?.isHighlighted = true
        }
    }
    
    private(set) var preWatchItem: IndexPath? {
        didSet {
            lastWatchButton.isHidden = preWatchItem == nil
        }
    }
    
    func setPreWatchItem(_ item: IndexPath?) {
        preWatchItem = item
    }
    
    var latestWatchCell: EpisodeCell? {
        return episodesView.cellForItem(at: model.latestWatchItem) as? EpisodeCell
    }
    
    var selectedItem: IndexPath?
    
    var lockScrollUpdate = false
    
    var timerWaitForVideo: Timer?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.black
        
        thumbnailBg = UIImageView()
        thumbnailBg.backgroundColor = .black
        thumbnailBg.contentMode = .scaleAspectFill
        view.addSubview(thumbnailBg)
        
        thumbnailBlur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.addSubview(thumbnailBlur)
        
        thumbnailShadow = UIImageView(image: UIImage(named: "shadow_thumb_bg"))
        thumbnailShadow.contentMode = .scaleToFill
        view.addSubview(thumbnailShadow)
        
        seasonMaskWindow = UIView(frame: .zero)
        seasonMaskWindow.layer.cornerRadius = 14
        seasonMaskWindow.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(seasonMaskWindow)
        
        let layout = EpisodesLayout.full
        episodesView = EpisodesView(frame: .zero, collectionViewLayout: layout)
        episodesView.dataSource = self
        episodesView.delegate = self
        episodesView.prefetchDataSource = self
        episodesView.register(EpisodeCell.self, forCellWithReuseIdentifier: "episode")
        episodesView.backgroundColor = UIColor.clear
        episodesView.decelerationRate = UIScrollView.DecelerationRate(rawValue: UIScrollView.DecelerationRate.normal.rawValue + (UIScrollView.DecelerationRate.fast.rawValue - UIScrollView.DecelerationRate.normal.rawValue) / 1.5)
        view.addSubview(episodesView)
        
        seasonsView = SeasonsView.genSeasonsView()
        seasonsView.isScrollEnabled = false
        seasonsView.dataSource = self
        seasonsView.delegate = self
        view.addSubview(seasonsView)
        
        lastWatchButton = UIButton(type: .custom)
        lastWatchButton.setImage(UIImage(named: "turn_back"), for: .normal)
        lastWatchButton.addTarget(self, action: #selector(handleLastWatchButton), for: .touchUpInside)
        lastWatchButton.isHidden = true
        view.addSubview(lastWatchButton)
        
        let shadowLeftImg = UIImage(named: "shadow_left")
        shadowLeft = UIImageView(image: shadowLeftImg)
        shadowLeft.contentMode = .left
        shadowLeft.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        view.addSubview(shadowLeft)
        
        let shadowRightCGImg = shadowLeftImg?.cgImage?.copy()
        let shadowRightImg = UIImage(cgImage: shadowRightCGImg!, scale: 1, orientation: .down)
        shadowRight = UIImageView(image: shadowRightImg)
        shadowRight.contentMode = .right
        shadowRight.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        view.addSubview(shadowRight)
        
        thumbnailBg.frame = view.bounds
        thumbnailBlur.frame = view.bounds
        thumbnailShadow.frame = view.bounds
        shadowLeft.frame = view.bounds
        shadowRight.frame = view.bounds
        
        episodesView.contentInset = UIEdgeInsets(top: 0, left: screenHeight / 2, bottom: 0, right: screenHeight / 2)
        
        layoutFullScreenOrNot = true
    }
    
    override func viewDidLoad() {
        episodesView.scrollToItem(at: model.latestWatchItem, at: .centeredHorizontally, animated: false)
        seasonsView.scrollToItem(at: IndexPath(row: model.latestWatchItem.section, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.viewStore.subscribe(self) { subcription in
            subcription.select { viewState in
                viewState.scene
            }
        }
        
        self.model.pageDataManager.fetchVideo(self.model.latestWatchItem) { (video, _) in
            FullscreenVideoManager.current.gotoWindow(video: video, window: self.view)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .goToEpisodesView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .exitFullscreen, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.willToScene()
        self.latestWatchCell!.configure4Full()
        self.model.pageDataManager.fetchVideo(self.model.latestWatchItem) { (video, _) in
            FullscreenVideoManager.current.gotoCell()
            self.latestWatchCell!.mountVideo(video)
            self.extraSceneAnimation()
            self.didToScene()
            DispatchQueue.main.async {
                self.model.viewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        preSceneState = nil
        model.viewStore.unsubscribe(self)
        NotificationCenter.default.removeObserver(self)
    }
}
