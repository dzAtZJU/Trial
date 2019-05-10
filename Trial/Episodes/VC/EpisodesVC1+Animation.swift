//
//  EpisodesVC1+Animation.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//
//
//import Foundation
//import UIKit
//import CoreGraphics
//
//extension EpisodesVC {
//    func newState(state: EpisodesSceneState) {
//        switch state {
//        case .sliding:
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView.collectionViewLayout = EpisodesLayout.sliding
//                for cell in self.collectionView.visibleCells {
//                    cell.layoutIfNeeded()
//                }
//            }, completion: nil)
//        case .watching:
//            let newLayout = EpisodesLayout.watching
//            let transformForVideo = CGAffineTransform(scaleX: newLayout.itemSize.width / self.layout.itemSize.width, y: newLayout.itemSize.height / self.layout.itemSize.height)
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView.collectionViewLayout = newLayout
//                 self.inFocusVideo.transform = self.inFocusVideo.transform.concatenating(transformForVideo)
//                for cell in self.collectionView.visibleCells {
//                    cell.layoutIfNeeded()
//                }
//            }, completion: nil)
//        case .watching2Full:
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView.collectionViewLayout = EpisodesLayout.watching2Full
//                for cell in self.collectionView.visibleCells {
//                    cell.layoutIfNeeded()
//                }
//            }, completion: { _ in
//                episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
//            })
//        case .full:
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView.collectionViewLayout = EpisodesLayout.full
//                for cell in self.collectionView.visibleCells {
//                    cell.layoutIfNeeded()
//                }
//            }, completion: nil)
//        case .full2Watching:
//            let newLayout = EpisodesLayout.full2Watching
//            let transformForVideo = CGAffineTransform(scaleX: newLayout.itemSize.width / self.layout.itemSize.width, y: newLayout.itemSize.height / self.layout.itemSize.height)
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView.collectionViewLayout = newLayout
//                self.inFocusVideo.transform = self.inFocusVideo.transform.concatenating(transformForVideo)
//                for cell in self.collectionView.visibleCells {
//                    cell.layoutIfNeeded()
//                }
//            }, completion: { _ in
//                episodesViewStore.dispatch(EpisodesViewState.SceneAction.touchCell)
//            })
//        }
//    }
//}
