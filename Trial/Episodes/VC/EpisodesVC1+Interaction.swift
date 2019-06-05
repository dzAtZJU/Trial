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
        if !scrollView.isDecelerating {
            episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
            preWatchItem = nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let item = episodesView.indexPathForItem(at: episodesView.bounds.center) {
            if item.section != centerItem.section {
                seasonsView.scrollToItem(at: IndexPath(row: item.section, section: 0), at: [.centeredHorizontally], animated: true)
            }
            centerItem = item
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            didEndScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndScroll()
    }
    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if let selectedItem = selectedItem {
//            seasonsView.performBatchUpdates({
//                self.latestWatchItem = selectedItem
//                self.layout.invalidateLayout()
//            }, completion: nil)
//        }
//    }
    
    private func didEndScroll() {
        latestWatchItem = centerItem
        pageDataManager.fetchVideo(latestWatchItem) { (video, _) in
            self.latestWatchCell?.mountVideo(video)
            episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsView {
            selectedItem = IndexPath(row: 0, section: indexPath.row)
            latestWatchItem = selectedItem
            self.layout.invalidateLayout()
            self.episodesView.scrollToItem(at: self.selectedItem!, at: .centeredHorizontally, animated: true)
            return
        }
        
        episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == latestWatchItem {
            preWatchItem = latestWatchItem
        }
    }
    
    @objc func handleLastWatchButton() {
        if let preWatchItem = preWatchItem {
            latestWatchItem = preWatchItem
            self.preWatchItem = nil
            layout.invalidateLayout()
            episodesView.scrollToItem(at: preWatchItem, at: .centeredHorizontally, animated: true)
        }
    }
}
