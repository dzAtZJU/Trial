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

class EpisodesVC: UIViewController {
    
    // Views
    
    var maskWindow: UIView!
    
    var seasonsView: UICollectionView!
    
    var episodesView: UICollectionView!
    
    var blurredThumbnailBg: UIImageView!
    
    var shadowBlurredThumbnailBg: UIImageView!
    
    var shadowLeft: UIImageView!
    
    var shadowRight: UIImageView!
    
    var lastWatchButton: UIButton!
    
    let pageDataManager = PageDataManager()
    
    var layout: EpisodesLayout {
        return episodesView.collectionViewLayout as! EpisodesLayout
    }
    
    // Layout Alternate
    
    var preSceneState = EpisodesSceneState.sliding
    
    // States
    var centerItem: IndexPath! = IndexPath(row: 0, section: 0)
    
    var latestWatchItem: IndexPath! = IndexPath(row: 0, section: 0)
    
    var preWatchItem: IndexPath? {
        didSet {
            lastWatchButton.isHidden = preWatchItem == nil
        }
    }
    
    var latestWatchCell: EpisodeCell? {
        return episodesView.cellForItem(at: latestWatchItem) as? EpisodeCell
    }
    
    var selectedItem: IndexPath?
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.black
        
        blurredThumbnailBg = UIImageView()
        blurredThumbnailBg.backgroundColor = UIColor.yellow
        blurredThumbnailBg.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(blurredThumbnailBg)
        
        shadowBlurredThumbnailBg = UIImageView(image: UIImage(named: "shadow_thumb_bg"))
        shadowBlurredThumbnailBg.contentMode = .scaleToFill
        shadowBlurredThumbnailBg.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        view.addSubview(shadowBlurredThumbnailBg)
        
        maskWindow = UIView(frame: .zero)
        maskWindow.layer.cornerRadius = 14
        maskWindow.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(maskWindow)
        
        let layout = EpisodesLayout.sliding
        episodesView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        lastWatchButton = UIButton(type: .custom)
        lastWatchButton.setImage(UIImage(named: "last_watch_button"), for: .normal)
        lastWatchButton.addTarget(self, action: #selector(handleLastWatchButton), for: .touchUpInside)
        lastWatchButton.isHidden = true
        view.addSubview(lastWatchButton)
    }
    
    override func viewWillLayoutSubviews() {
        layoutShadows()
        layoutSeasonsView()
        layoutEpisodesView()
        lastWatchButton.frame = CGRect(origin: CGPoint(x: view.bounds.width - 60, y: 10), size: CGSize(width: 50, height: 50))
    }
    
    private func layoutShadows() {
        blurredThumbnailBg.frame = view.bounds
        shadowBlurredThumbnailBg.frame = view.bounds
        shadowLeft.frame = view.bounds
        shadowRight.frame = view.bounds
    }
    
    private func layoutSeasonsView() {
        seasonsView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 96))
        maskWindow.frame = CGRect(center: seasonsView.center, size: CGSize(width: 102, height: 28))
    }
    
    private func layoutEpisodesView() {
        episodesView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: -100, bottom: -32, right: -100))
        episodesView.contentInset = UIEdgeInsets(top: 0, left: screenHeight / 2, bottom: 0, right: screenHeight / 2)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewDidLoad() {
        prepareForPresent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        seasonsView.scrollToItem(at: IndexPath(row: latestWatchItem.section, section: 0), at: .centeredHorizontally, animated: false)
        view.window?.addSubview(activityIndicator)
    }
}

extension EpisodesVC: StoreSubscriber {
    func newState(state: EpisodesSceneState) {
        newStateForAnimation(state: state)
        preSceneState = state
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodesViewStore.subscribe(self) { subcription in
            subcription.select { viewState in
                viewState.scene
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        episodesViewStore.unsubscribe(self)
    }
}
