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
            animator.addAnimations {
                self.episodesView.collectionViewLayout = EpisodesLayout.sliding
            }
            animator.addCompletion { _ in
                (self.episodesView.cellForItem(at: self.model.latestWatchItem) as? EpisodeCell)?.unMountVideo()
            }
        case .watching:
            if preSceneState == .sliding {
                animator.addAnimations {
                    self.episodesView.collectionViewLayout = EpisodesLayout.watching
                }
            } else {
                animator.addAnimations {
                    self.episodesView.collectionViewLayout = EpisodesLayout.full2Watching
                    self.latestWatchCell?.layoutIfNeeded()
                }
                
                animator1.addAnimations {
                    self.episodesView.collectionViewLayout = EpisodesLayout.watching
                }
            }
        case .full:
            animator.addAnimations {
                self.episodesView.collectionViewLayout = EpisodesLayout.watching2Full
            }
            animator1.addAnimations {
                self.episodesView.collectionViewLayout = EpisodesLayout.full
            }
        default:
            fatalError()
        }
        
        willToScene()
        
        animator1.addAnimations {}
        let mainAnimator = state == .full ? animator1 : animator
        mainAnimator.addAnimations {
            self.extraSceneAnimation()
        }
        
        animator.addCompletion { _ in
            self.didToScene()
        }
        
        animator.startAnimation()
        animator1.startAnimation(afterDelay: delay)
    }

    func willToScene() {
        lockScrollUpdate = true
        
        switch model.viewStore.state.scene {
        case .watching:
            self.model.pageDataManager.get(self.model.latestWatchItem, completion: { data in
                DispatchQueue.main.async {
                    self.thumbnailBg.image = data.thumbnail
                }
            })
        default:
            return
        }
    }
    
    func extraSceneAnimation() {
        let isFull = model.viewStore.state.scene == .full
        let isSliding = model.viewStore.state.scene == .sliding
        let isWatching = model.viewStore.state.scene == .watching
        
        if isFull || isWatching {
            layoutFullScreenOrNot = isFull
        }
        
        self.latestWatchCell?.videoFullScreenOrNot = isFull
        
        if isFull || isSliding {
            self.latestWatchCell?.imageCenterOrFill = isSliding
        }
    }
    
    func didToScene() {
        lockScrollUpdate = false
    }
}
