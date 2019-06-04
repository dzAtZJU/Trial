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
let watchingHeight: CGFloat = 243

extension EpisodesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == seasonsView {
            return seasonSize
        }
        
        guard indexPath == latestWatchItem else {
            return CGSize(width: 120, height: 225)
        }
        
        let layout = collectionViewLayout as! EpisodesLayout
        switch layout.sceneState {
        case .watching, .watching2Full, .full2Watching:
            return CGSize(width: 432, height: watchingHeight)
        case .full:
            return CGSize(width: 667, height: 375)
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
}
