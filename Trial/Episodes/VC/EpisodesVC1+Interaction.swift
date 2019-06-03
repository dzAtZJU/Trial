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
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let item = episodesView.indexPathForItem(at: episodesView.bounds.center), (item.section + 1) != centerSeason {
            seasonsView.scrollToItem(at: IndexPath(row: item.section, section: 0), at: [.centeredHorizontally], animated: true)
            centerSeason = item.section + 1
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
    
    private func didEndScroll() {
        for cell in episodesView.visibleCells {
            if cell.frame.contains(episodesView.bounds.center) {
                inFocusItem = episodesView.indexPath(for: cell)
            }
        }
        
        episodesViewStore.dispatch(EpisodesViewState.SceneAction.scroll)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inFocusItem = indexPath
        episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
    }
}
