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

let duration = 0.4
let delay = 0.2
let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: nil)
let animator1 = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: nil)

extension EpisodesVC {
    func newStateForAnimation(state: EpisodesSceneState) {
        switch state {
        case .sliding:
            UIView.animate(withDuration: duration, animations: {
                self.latestWatchCell?.hideContent = true
                self.episodesView.collectionViewLayout = EpisodesLayout.sliding
                for cell in self.episodesView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }, completion: { _ in
                self.pageDataManager.fetchVideo(self.latestWatchItem) { (video, _) in
                    let cell = self.episodesView.cellForItem(at: self.latestWatchItem)! as! EpisodeCell
                    cell.unMountVideo()
                }
            })
        case .watching:
            if preSceneState == .sliding {
                let newLayout = EpisodesLayout.watching
                UIView.animate(withDuration: duration, animations: {
                    self.episodesView.collectionViewLayout = newLayout
                    self.latestWatchCell?.hideContent = false
                    for cell in self.episodesView.visibleCells {
                        cell.layoutIfNeeded()
                    }
                }, completion: nil)
                return
            }
            
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: nil)
            
            let newLayout = EpisodesLayout.full2Watching
            
            animator.addAnimations {
                self.latestWatchCell?.videoFullScreen = false
                self.latestWatchCell?.toggleImageContentMode()
                self.episodesView.collectionViewLayout = newLayout
                self.episodesView.center = self.episodesView.center + CGPoint(x: 0, y: 16)
                self.seasonsView.center = self.seasonsView.center + CGPoint(x: 0, y: 62)
                self.maskWindow.center = self.maskWindow.center + CGPoint(x: 0, y: 62)
                for cell in self.episodesView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }
            
            
            animator1.addAnimations {
                self.episodesView.collectionViewLayout = EpisodesLayout.watching
            }
            
            animator.startAnimation()
            animator1.startAnimation(afterDelay: delay)
        case .full:
            let newLayout = EpisodesLayout.watching2Full
            
            animator.addAnimations {
                self.episodesView.collectionViewLayout = newLayout
            }
            
            animator1.addAnimations {
                self.latestWatchCell?.toggleImageContentMode()
                self.latestWatchCell?.videoFullScreen = true
                self.episodesView.collectionViewLayout = EpisodesLayout.full
                self.episodesView.center = self.episodesView.center - CGPoint(x: 0, y: 16)
                self.seasonsView.center = self.seasonsView.center - CGPoint(x: 0, y: 62)
                self.maskWindow.center = self.maskWindow.center - CGPoint(x: 0, y: 62)
                for cell in self.episodesView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }
            
            animator.startAnimation()
            animator1.startAnimation(afterDelay: delay)
        default:
            fatalError()
        }
    }
}

