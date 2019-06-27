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
        let sceneState = model.viewStore.state.scene
        
        switch sceneState {
        case .watching:
            willSlide()
        case .sliding:
            willKeepSlide()
        default:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !lockScrollUpdate else {
            return
        }
        
        if let newCenterItem = episodesView.indexPathForItem(at: episodesView.bounds.center) {
            if newCenterItem.section != centerItem.section {
                seasonsView.scrollToItem(at: IndexPath(row: newCenterItem.section, section: 0), at: [.centeredHorizontally], animated: true)
            }
            if centerItem != newCenterItem {
                centerItem = newCenterItem
            }
        }
        
        if let latestWatchCell = latestWatchCell, !autoScrollFlag {
            let centerInViewport = view.convert(latestWatchCell.center, from: episodesView)
            let isOutOfViewport =  centerInViewport.x < 0 || centerInViewport.x > view.bounds.width
            if isOutOfViewport {
                setPreWatchItem(model.latestWatchItem)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            didStopSlide()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didStopSlide()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsView {

            doAutoSlide(IndexPath(row: 0, section: indexPath.row))
            
        } else if collectionView == episodesView {
            
            let sceneState = model.viewStore.state.scene
            switch sceneState {
            case .sliding:
                doAutoSlide(indexPath)
            case .watching:
                model.viewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
            default:
                return
            }
        }
    }
    
    @objc func handleLastWatchButton() {
        if let preWatchItem = preWatchItem {
            setPreWatchItem(nil)
            doAutoSlide(preWatchItem)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if !autoScrollFlag {
            return
        }
        autoScrollFlag = false
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            DispatchQueue.main.async {
                self.didStopSlide()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == episodesView {
            (cell as! EpisodeCell).unMountVideo()
        }
    }
    
    private func willSlide(completion: (() -> ())? = nil) {
        setPreWatchItem(nil)
        if let completion = completion {
            layoutAnimationComplections.append(completion)
        }
        model.viewStore.dispatch(EpisodesViewState.SceneAction.scroll)
    }
    
    private func willKeepSlide() {
        latestWatchCell?.unMountVideo()
    }
    
    private func doAutoSlide(_ to: IndexPath) {
        autoScrollFlag = true
        
        switch model.viewStore.state.scene {
        case .watching:
            willSlide() {
                self.episodesView.scrollToItem(at: to, at: .centeredHorizontally, animated: true)
            }
        case .sliding:
            willKeepSlide()
            episodesView.scrollToItem(at: to, at: .centeredHorizontally, animated: true)
        default:
            break
        }
    }
    
    private func didStopSlide() {
        model.setLatestWatchItem(centerItem)
        model.pageDataManager.fetchVideo(model.latestWatchItem) { (video, _) in
            self.latestWatchCell?.mountVideo(video)
            video.eventDelegate = self
        }
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .exitFullscreen:
            transferVideoId = model.pageDataManager.item2VideoId[model.latestWatchItem]
            (presentingViewController as! RippleVC).prepareForReAppear()
            dismiss(animated: false, completion: nil)
        case .goToEpisodesView:
            model.viewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
        default:
            return
        }
    }
}

extension EpisodesVC: VideoEventDelegate {
    func videoDidPlay(_ video: VideoWithPlayerView) {
        video.eventDelegate = nil
        model.viewStore.dispatch(EpisodesViewState.SceneAction.scroll)
    }
}
