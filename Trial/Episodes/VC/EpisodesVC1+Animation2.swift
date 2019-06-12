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
        lockScrollUpdate = true
        animator.addCompletion { _ in
            self.lockScrollUpdate = false
         }
        
        switch state {
        case .sliding:
            animator.addAnimations {
                self.latestWatchCell?.hideContent = true
                self.episodesView.collectionViewLayout = EpisodesLayout.sliding
                for cell in self.episodesView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }
            animator.addCompletion { _ in
                (self.episodesView.cellForItem(at: self.latestWatchItem) as? EpisodeCell)?.unMountVideo()
            }
        case .watching:
            if preSceneState == .sliding {
                animator.addAnimations {
                    self.pageDataManager.get(self.latestWatchItem, completion: { data in
                        DispatchQueue.main.async {
                            self.thumbnailBg.image = data.thumbnail
                        }
                    })
                    self.episodesView.collectionViewLayout = EpisodesLayout.watching
                    self.latestWatchCell?.hideContent = false
                    for cell in self.episodesView.visibleCells {
                        cell.layoutIfNeeded()
                    }
                }
            } else {
//                FullscreenVideoManager.current.gotoCell { video in
//                    self.latestWatchCell?.addVideoToHierarchy(video)
//                }
                
                animator.addAnimations {
                    self.latestWatchCell?.videoFullScreen = false
                    self.episodesView.collectionViewLayout = EpisodesLayout.full2Watching
                    self.episodesView.center = self.episodesView.center + CGPoint(x: 0, y: 16)
                    self.seasonsView.center = self.seasonsView.center + CGPoint(x: 0, y: 62)
                    self.seasonMaskWindow.center = self.seasonMaskWindow.center + CGPoint(x: 0, y: 62)
                    for cell in self.episodesView.visibleCells {
                        cell.layoutIfNeeded()
                    }
                }
                
                animator1.addAnimations {
                    self.episodesView.collectionViewLayout = EpisodesLayout.watching
                }
                
                animator1.addCompletion { _ in
                    self.latestWatchCell?.toggleImageContentMode()
                    self.pageDataManager.fetchVideo(self.latestWatchItem) { video, _ in
                        video.isUserInteractionEnabled = false
                    }
                }
            }
        case .full:
            animator.addAnimations {
                self.episodesView.collectionViewLayout = EpisodesLayout.watching2Full
            }
            animator1.addAnimations {
                self.latestWatchCell?.toggleImageContentMode()
                self.latestWatchCell?.videoFullScreen = true
                self.episodesView.collectionViewLayout = EpisodesLayout.full
                self.episodesView.center = self.episodesView.center - CGPoint(x: 0, y: 16)
                self.seasonsView.center = self.seasonsView.center - CGPoint(x: 0, y: 62)
                self.seasonMaskWindow.center = self.seasonMaskWindow.center - CGPoint(x: 0, y: 62)
                for cell in self.episodesView.visibleCells {
                    cell.layoutIfNeeded()
                }
            }
            
            animator1.addCompletion { _ in
                self.pageDataManager.fetchVideo(self.latestWatchItem) { video, _ in
                    video.isUserInteractionEnabled = true
                }
            }
//            animator1.addCompletion { _ in
//                self.pageDataManager.fetchVideo(self.latestWatchItem) { video, _ in
//                    FullscreenVideoManager.current.gotoWindow(video: video, window: self.view.window!)
//                }
//            }
        default:
            fatalError()
        }
        
        animator.startAnimation()
        animator1.addAnimations {}
        animator1.startAnimation(afterDelay: delay)
    }
}

