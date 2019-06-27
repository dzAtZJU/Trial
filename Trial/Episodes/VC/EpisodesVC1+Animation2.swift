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
var layoutAnimationComplections = [() -> ()]()
extension EpisodesVC {
    func newStateForAnimation(state: EpisodesSceneState) {
        switch state {
        case .sliding:
            animator.addAnimations {
                self.episodesView.collectionViewLayout = EpisodesLayout.sliding
                self.latestWatchCell?.animate2Sliding()
            }
            animator.addCompletion { _ in
                (self.episodesView.cellForItem(at: self.model.latestWatchItem) as? EpisodeCell)?.unMountVideo()
            }
        case .watching:
            if preSceneState == .sliding {
                animator.addAnimations {
                    self.episodesView.collectionViewLayout = EpisodesLayout.watching
                    self.latestWatchCell?.animate2Watching()
                }
            } else {
                animator.addAnimations {
                    self.episodesView.collectionViewLayout = EpisodesLayout.full2Watching
                    self.latestWatchCell?.animate2Watching()
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
                self.latestWatchCell?.animate2Full()
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
            layoutAnimationComplections.forEach {
                $0()
            }
            layoutAnimationComplections.removeAll()
        }
        
        animator.startAnimation()
        animator1.startAnimation(afterDelay: delay)
    }

    func willToScene() {
        lockScrollUpdate = true
        
        let sceneState = model.viewStore.state.scene
        
        if sceneState == .watching {
            self.model.pageDataManager.get(self.model.latestWatchItem, completion: { data in
                DispatchQueue.main.async {
                    self.thumbnailBg.image = data.thumbnail
                }
            })
        }
        
        latestWatchCell?.imageCenterOrFill = sceneState == .sliding || preSceneState! == .sliding
    }
    
    func extraSceneAnimation() {
        let isFull = model.viewStore.state.scene == .full
        let isSliding = model.viewStore.state.scene == .sliding
        let isWatching = model.viewStore.state.scene == .watching
        
        if isFull || isWatching {
            layoutFullScreenOrNot = isFull
        }
    }
    
    func didToScene() {
        lockScrollUpdate = false
    }
}
