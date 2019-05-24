//
//  EpisodesVC1+Animation2.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/9.
//  Copyright © 2019 周巍然. All rights reserved.
//


import Foundation
import UIKit
import CoreGraphics

let animator = UIViewPropertyAnimator(duration: 1, curve: UIView.AnimationCurve.easeInOut, animations: nil)
extension EpisodesVC {
    func newState(state: EpisodesSceneState) {
        switch state {
        case .sliding:
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.collectionViewLayout = EpisodesLayout.sliding
                for cell in self.collectionView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }, completion: nil)
        case .watching:
            let newLayout = EpisodesLayout.watching
//            let transformForVideo = CGAffineTransform(scaleX: newLayout.itemSize.width / self.layout.itemSize.width, y: newLayout.itemSize.height / self.layout.itemSize.height)
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.collectionViewLayout = newLayout
//                self.inFocusVideo.transform = self.inFocusVideo.transform.concatenating(transformForVideo)
                for cell in self.collectionView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }, completion: nil)
        case .full:
            animator.addAnimations {
                self.collectionView.collectionViewLayout = EpisodesLayout.watching2Full
            }
            animator.startAnimation()
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                animator.addAnimations {
                    self.collectionView.collectionViewLayout = EpisodesLayout.full
                }
            }
            
            
        case .full2Watching:
            let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: nil)
            
            let newLayout = EpisodesLayout.full2Watching
//            let transformForVideo = CGAffineTransform(scaleX: newLayout.itemSize.width / self.layout.itemSize.width, y: newLayout.itemSize.height / self.layout.itemSize.height)
            animator.addAnimations {
                self.collectionView.collectionViewLayout = newLayout
//                self.inFocusVideo.transform = self.inFocusVideo.transform.concatenating(transformForVideo)
                for cell in self.collectionView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }
            animator.addAnimations({
                self.collectionView.collectionViewLayout = EpisodesLayout.watching
            }, delayFactor: 0.7)
            
            animator.startAnimation()
        default:
            fatalError()
        }
    }
}

