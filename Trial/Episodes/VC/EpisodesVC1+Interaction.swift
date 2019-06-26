//
//  EpisodesVC1+Animation.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.


import Foundation
import UIKit
import CoreGraphics
import ReSwift

extension EpisodesVC: UICollectionViewDelegate, StoreSubscriber {
    
    func newState(state: EpisodesSceneState) {
        guard preSceneState != nil else {
            preSceneState = state
            return
        }
        
        newStateForAnimation(state: state)
        preSceneState = state
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        if model.viewStore.state.scene == .watching {
            prepareSliding()
        }
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
        
        if let latestWatchCell = latestWatchCell, !autoScrollFlag {
            let centerInViewport = view.convert(latestWatchCell.center, from: episodesView)
            let isOutOfViewport =  centerInViewport.x < 0 || centerInViewport.x > view.bounds.width
            preWatchItem = isOutOfViewport ? model.latestWatchItem : nil
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            prepareWatching(delay: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        prepareWatching(delay: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsView {
            selectedItem = IndexPath(row: 0, section: indexPath.row)
            preWatchItem = model.latestWatchItem
            prepareAutoSliding(to: selectedItem!)
            return
        }
        
        if model.viewStore.state.scene == .sliding {
            prepareWatching(delay: false)
        } else {
            model.viewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
        }
    }
    
    @objc func handleLastWatchButton() {
        if let preWatchItem = preWatchItem {
            self.preWatchItem = nil
            prepareAutoSliding(to: preWatchItem)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard autoScrollFlag == autoScrollFlag, let latestWatchCell = latestWatchCell else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            DispatchQueue.main.async {
                self.autoScrollFlag = false
                self.model.pageDataManager.fetchVideo(self.model.latestWatchItem) { (video, _) in
                    latestWatchCell.mountVideo(video)
                }
                self.willToScene()
                self.didToScene()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == episodesView {
            (cell as! EpisodeCell).unMountVideo()
        }
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .exitFullscreen:
            transferVideoId = model.pageDataManager.item2VideoId[model.latestWatchItem]
            dismiss(animated: false, completion: nil)
        case .goToEpisodesView:
            model.viewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
        default:
            return
        }
    }
    
    private func prepareSliding() {
        if !seasonsView.isDecelerating {
            model.viewStore.dispatch(EpisodesViewState.SceneAction.scroll)
            preWatchItem = nil
        }
    }
    
    
    private func prepareWatching(delay: Bool) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay ? 1 : 0, repeats: false, block: { _ in
            DispatchQueue.main.async {
                self.model.latestWatchItem = self.centerItem
                self.model.pageDataManager.fetchVideo(self.model.latestWatchItem) { (video, _) in
                    self.latestWatchCell?.mountVideo(video)
                    self.model.viewStore.dispatch(EpisodesViewState.SceneAction.scroll)
                }
            }
        })
    }
    
    func prepareAutoSliding(to: IndexPath) {
        self.latestWatchCell?.unMountVideo()
        
        model.latestWatchItem = to
        self.layout.invalidateLayout()
        self.episodesView.scrollToItem(at: to, at: .centeredHorizontally, animated: true)
        autoScrollFlag = true
    }
}
