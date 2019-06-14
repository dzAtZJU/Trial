//
//  RippleVC+.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension RippleVC {
    // Animation Category 1: Orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        lockScrollUpdate = true
        super.viewWillTransition(to: size, with: coordinator)
        
        if animationQueue.isEmpty && (rippleViewStore.state.scene != .full) {
            executeAnimationByNewState = false
            let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnRotate())
            let newLayout = self.layout.nextOnRotate()
            let transformForVideo = self.layout.uiTemplates.transformForCenterItemTo(newLayout.uiTemplates)
            animationQueue.append {
                self.collectionView.collectionViewLayout = self.layout.nextOnRotate()
                self.inFocusCell.videoWithPlayer?.transform = self.inFocusCell.videoWithPlayer!.transform.concatenating(transformForVideo)
                shadowAnimation()
            }
            completionQueue.append {
                shadowCompletion()
            }
        }

        if !executeAnimationByNewState {
            coordinator.animate(alongsideTransition: { _ in
                self.runQueuedAnimation()
                self.updateContentInset()
            }, completion: { _ in
                self.runQueuedCompletion()
                self.animationQueue.removeAll()
                self.completionQueue.removeAll()
                self.lockScrollUpdate = false
            })
        }
    }
    
    // Animation Category 2: Scene State change
    func newStateForAnimation(state: RippleSceneState) {
        executeAnimationByNewState = true
        
        switch state {
        case .watching:
            switch preSceneState {
            case .full:
                let newLayout = UIDevice.current.orientation.isPortrait ? self.layout.nextOnFullPortrait(): self.layout.nextOnFullLandscape()
                let transformForVideo = self.layout.uiTemplates.transformForCenterItemTo(newLayout.uiTemplates)
                let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnExit(isPortrait: UIDevice.current.orientation.isPortrait))
                animationQueue.append {
                    self.collectionView.collectionViewLayout = newLayout
                    self.inFocusCell.videoWithPlayer?.transform = self.inFocusCell.videoWithPlayer!.transform.concatenating(transformForVideo)
                    shadowAnimation()
                }
                completionQueue.append {
                    shadowCompletion()
                }
                if UIDevice.current.orientation.isPortrait {
                    executeAnimationByNewState = false
                    UIDevice.current.triggerInterfaceRotateForEixtFullscreen()
                }
            case .surfing:
                let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnScene())
                animationQueue.append {
                    self.collectionView.collectionViewLayout = self.layout.nextOnScene().nextOnMove(self.selectedItem)
                    shadowAnimation()
                }
                completionQueue.append {
                    shadowCompletion()
                    YoutubeManager.shared.fetchVideoForItem(self.inFocusItem) { video, _ in
                        self.inFocusCell.mountVideo(video)
                    }
                }
            default:
                fatalError()
            }
        case .surfing:
            inFocusCell.unMountVideo()
            let (shadowAnimation, shadowCompletion) = installShadow(shadow.nextOnScene())
            animationQueue.append {
                self.collectionView.collectionViewLayout = self.layout.nextOnScene()
                shadowAnimation()
            }
            completionQueue.append {
                shadowCompletion()
            }
        case .full:
            let (shadowAnimation, shadowCompletion) = installShadow(Shadow.dumb)
            let newLayout = UIScreen.main.isPortrait ? self.layout.nextOnFullPortrait(): self.layout.nextOnFullLandscape()
            let transformForVideo = self.layout.uiTemplates.transformForCenterItemTo(newLayout.uiTemplates)
            animationQueue.append {
                self.collectionView.collectionViewLayout = newLayout
                self.inFocusCell.videoWithPlayer!.transform = self.inFocusCell.videoWithPlayer!.transform.concatenating(transformForVideo)
                shadowAnimation()
            }
            completionQueue.append {
                shadowCompletion()
            }
            if UIScreen.main.isPortrait {
                executeAnimationByNewState = false
                UIDevice.current.triggerInterfaceRotateForFullscreen()
            }
        }
        
        willlAnimate()
        if executeAnimationByNewState {
            UIView.animate(withDuration: 0.3, animations: {
                self.runQueuedAnimation()
            }) { _ in
                self.runQueuedCompletion()
                self.animationQueue.removeAll()
                self.completionQueue.removeAll()
            }
        }
    }
    
    func willlAnimate() {
        YoutubeManager.shared.fetchVideoForItem(self.inFocusItem) { video, _ in
            video.isUserInteractionEnabled = rippleViewStore.state.scene == .full
        }
        self.collectionView.isScrollEnabled = rippleViewStore.state.scene != .full
    }
    
    func runQueuedAnimation() {
        for animation in self.animationQueue {
            animation()
        }
        subviewsReLayoutAnimation()
    }
    
    func runQueuedCompletion() {
        for completion in self.completionQueue {
            completion()
        }
    }
    
    func subviewsReLayoutAnimation() {
        for cell in self.collectionView.visibleCells {
            cell.layoutIfNeeded()
        }
    }
    
    func installShadow(_ newShadow: Shadow) -> (() -> Void, () -> Void) {
        guard TestState != 1 else {
            return ({}, {})
        }
        if newShadow != Shadow.dumb {
            newShadow.frame = view.bounds
            newShadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            newShadow.alpha = 0
            view.addSubview(newShadow)
        }
        
        return ({ self.shadow.alpha = 0
            if newShadow != Shadow.dumb {
                newShadow.alpha = 1
            }
        }, {
            self.shadow.removeFromSuperview()
            self.shadow = newShadow
        })
    }
}
