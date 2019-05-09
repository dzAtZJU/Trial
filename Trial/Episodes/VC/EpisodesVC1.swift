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
    var collectionView: UICollectionView!
    
    var inFocusItem: IndexPath!
    
    var transferredVideo: VideoWithPlayerView!
    
    var blurredThumbnailBg: UIImageView!
    
    var shadowBlurredThumbnailBg: UIImageView!
    
    var shadowLeft: UIImageView!
    
    var shadowRight: UIImageView!
    
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
        
        let layout = EpisodesLayout.full
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: "episode")
        collectionView.backgroundColor = UIColor.clear
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(collectionView)
        
        let shadowLeftImg = UIImage(named: "shadow_left")
        shadowLeft = UIImageView(image: shadowLeftImg)
        shadowLeft.contentMode = .left
        shadowLeft.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(shadowLeft)
        
        let shadowRightCGImg = shadowLeftImg?.cgImage?.copy()
        let shadowRightImg = UIImage(cgImage: shadowRightCGImg!, scale: 1, orientation: .down)
        shadowRight = UIImageView(image: shadowRightImg)
        shadowRight.contentMode = .right
        shadowRight.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(shadowRight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.frame = view.bounds
        blurredThumbnailBg.frame = view.bounds
        shadowBlurredThumbnailBg.frame = view.bounds
        shadowLeft.frame = view.bounds
        shadowRight.frame = view.bounds
    }
}

extension EpisodesVC: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if cell.frame.contains(collectionView.bounds.center) {
                inFocusItem = collectionView.indexPath(for: cell)
            }
        }
        
        episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inFocusItem = indexPath
        episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
    }
}

extension EpisodesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episode", for: indexPath) as! EpisodeCell
        cell.episodeNum.text = indexPath.row.description
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
}

extension EpisodesVC: UICollectionViewDelegateFlowLayout, InFocusItemManager {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath == inFocusItem else {
            return CGSize(width: 120, height: 225)
        }

        let layout = collectionViewLayout as! EpisodesLayout
        switch layout.sceneState {
        case .watching, .watching2Full:
            return CGSize(width: 432, height: 243)
        case .full:
            return CGSize(width: 667, height: 375)
        case .full2Watching:
            return CGSize(width: 518, height: 292)
        case .sliding:
            return CGSize(width: 120, height: 225)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let layout = collectionViewLayout as! EpisodesLayout
        switch layout.sceneState {
        case .sliding:
            return CGFloat(10)
        case .watching:
            return CGFloat(20)
        case .full, .full2Watching:
            return CGFloat(200)
        case .watching2Full:
            return CGFloat(100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let layout = collectionViewLayout as! EpisodesLayout
        switch layout.sceneState {
        case .sliding:
            return CGFloat(10)
        case .watching:
            return CGFloat(20)
        case .full, .full2Watching:
            return CGFloat(200)
        case .watching2Full:
            return CGFloat(100)
        }
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
        collectionView.cellForItem(at: inFocusItem)?.addSubview(transferredVideo)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        episodesViewStore.unsubscribe(self)
    }
}
