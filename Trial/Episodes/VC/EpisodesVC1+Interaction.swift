//
//  EpisodesVC1+Animation.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.


import Foundation
import UIKit
import CoreGraphics

extension EpisodesVC: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        prepareSliding()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !lockScrollUpdate else {
            return
        }
        
        if let item = episodesView.indexPathForItem(at: episodesView.bounds.center) {
            if item.section != centerItem.section {
                seasonsView.scrollToItem(at: IndexPath(row: item.section, section: 0), at: [.centeredHorizontally], animated: true)
            }
            centerItem = item
        }
        
        if let latestWatchCell = latestWatchCell {
            let centerInViewport = view.convert(latestWatchCell.center, from: episodesView)
            let isOutOfViewport =  centerInViewport.x < 0 || centerInViewport.x > view.bounds.width
            preWatchItem = isOutOfViewport ? latestWatchItem : nil
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            prepareWatching()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        prepareWatching()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsView {
            selectedItem = IndexPath(row: 0, section: indexPath.row)
            prepareAutoSliding(to: selectedItem!)
            return
        }
        
        episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
    }
    
    @objc func handleLastWatchButton() {
        if let preWatchItem = preWatchItem {
            prepareAutoSliding(to: preWatchItem)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard autoScrollFlag, let latestWatchCell = latestWatchCell else {
            return
        }
        
        autoScrollFlag = false
        preWatchItem = nil
        pageDataManager.fetchVideo(latestWatchItem) { (video, _) in
            latestWatchCell.mountVideo(video)
            UIView.animate(withDuration: duration) {
                latestWatchCell.hideContent = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == episodesView {
            (cell as! EpisodeCell).unMountVideo()
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        seasonsView.scrollToItem(at: IndexPath(row: latestWatchItem.section, section: 0), at: .centeredHorizontally, animated: false)
        prepareWatching()
        view.window?.addSubview(activityIndicator)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .exitFullscreen:
            episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
        default:
            return
        }
    }
    
    private func prepareSliding() {
        if !seasonsView.isDecelerating {
            episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
            preWatchItem = nil
        }
    }
    
    private func prepareWatching() {
        latestWatchItem = centerItem
        pageDataManager.fetchVideo(latestWatchItem) { (video, _) in
            self.latestWatchCell?.mountVideo(video)
            episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
        }
    }
    
    private func prepareAutoSliding(to: IndexPath) {
        self.latestWatchCell?.unMountVideo()
        self.latestWatchCell?.hideContent = true
        
        latestWatchItem = to
        self.layout.invalidateLayout()
        self.episodesView.scrollToItem(at: to, at: .centeredHorizontally, animated: true)
        autoScrollFlag = true
    }
}
