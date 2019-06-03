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
    var maskWindow: UIView!
    
    var seasonsView: UICollectionView!
    
    var episodesView: UICollectionView!
    
    var inFocusItem: IndexPath!
    
    var inFocusVideo: VideoWithPlayerView!
    
    var blurredThumbnailBg: UIImageView!
    
    var shadowBlurredThumbnailBg: UIImageView!
    
    var shadowLeft: UIImageView!
    
    var shadowRight: UIImageView!
    
    var layout: EpisodesLayout {
        return episodesView.collectionViewLayout as! EpisodesLayout
    }
    
    var centerSeason = 1
    
    var preSceneState = EpisodesSceneState.sliding
    
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
        
        seasonsView = SeasonsView.genSeasonsView()
        seasonsView.isScrollEnabled = false
        seasonsView.dataSource = self
        seasonsView.delegate = self
        view.addSubview(seasonsView)
        
        let layout = EpisodesLayout.sliding
        episodesView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        episodesView.dataSource = self
        episodesView.delegate = self
        episodesView.register(EpisodeCell.self, forCellWithReuseIdentifier: "episode")
        episodesView.backgroundColor = UIColor.clear
        episodesView.decelerationRate = UIScrollView.DecelerationRate(rawValue: UIScrollView.DecelerationRate.normal.rawValue + (UIScrollView.DecelerationRate.fast.rawValue - UIScrollView.DecelerationRate.normal.rawValue) / 1.5)
        view.addSubview(episodesView)
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seasonsView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 96))
        seasonsView.scrollToItem(at: IndexPath(row: centerSeason - 1, section: 0), at: .centeredHorizontally, animated: false)
        maskWindow.frame = CGRect(center: seasonsView.center, size: CGSize(width: 102, height: 28))
        layoutEpisodesViewInDidLoad()
        blurredThumbnailBg.frame = view.bounds
        shadowBlurredThumbnailBg.frame = view.bounds
        shadowLeft.frame = view.bounds
        shadowRight.frame = view.bounds
    }
}

extension EpisodesVC: StoreSubscriber {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodesViewStore.subscribe(self) { subcription in
            subcription.select { viewState in
                viewState.scene
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
//        collectionView.cellForItem(at: inFocusItem)?.addSubview(inFocusVideo)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        episodesViewStore.unsubscribe(self)
    }
}
