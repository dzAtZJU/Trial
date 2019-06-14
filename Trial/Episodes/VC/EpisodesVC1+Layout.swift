//
//  EpisodesVC1+Layout.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/3.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

let seasonSize = CGSize(width: 57, height: 24)
let seasonSpacing: CGFloat = 75
let episodesTop: CGFloat = 82
let watchingHeight: CGFloat = 243 // 1.778
let watchingWidth: CGFloat = 432
let watchingSize = CGSize(width: watchingWidth, height: watchingHeight)


extension EpisodesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == seasonsView {
            return seasonSize
        }
        
        guard indexPath == model.latestWatchItem else {
            return CGSize(width: 120, height: 225)
        }
        
        let layout = collectionViewLayout as! EpisodesLayout
        switch layout.sceneState {
        case .watching, .watching2Full, .full2Watching:
            return CGSize(width: watchingWidth, height: watchingHeight)
        case .full:
            return EpisodeCell.aspectFull
        case .sliding:
            return CGSize(width: 120, height: 225)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == seasonsView {
            return seasonSpacing
        }
        
        let layout = collectionViewLayout as! EpisodesLayout
        switch layout.sceneState {
        case .sliding:
            return CGFloat(10)
        case .watching:
            return CGFloat(20)
        case .full, .watching2Full, .full2Watching:
            return CGFloat(80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == seasonsView {
            return seasonSpacing
        }
        
        let layout = collectionViewLayout as! EpisodesLayout
        switch layout.sceneState {
        case .sliding:
            return CGFloat(10)
        case .watching:
            return CGFloat(20)
        case .full, .watching2Full, .full2Watching:
            return CGFloat(80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == seasonsView {
            let margin = screenHeight / 2
            return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        }
        
        let spacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
        
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
    }
    
    var layoutFullScreenOrNot: Bool {
        get {
            return true
        }
        
        set(newValue) {
            seasonsView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 96))
            seasonMaskWindow.frame = CGRect(center: seasonsView.center, size: CGSize(width: 102, height: 28))
            episodesView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: -episodesViewHorizontalExtent, bottom: -32, right: -episodesViewHorizontalExtent))
            
            let diffYEpisodes = newValue ? CGPoint(x: 0, y: -16) : .zero
            self.episodesView.center = self.episodesView.center + diffYEpisodes
            
            let diffYSeasons = newValue ? CGPoint(x: 0, y: -62) : .zero
            self.seasonsView.center = self.seasonsView.center + diffYSeasons
            self.seasonMaskWindow.center = self.seasonMaskWindow.center + diffYSeasons
        }
    }
}
