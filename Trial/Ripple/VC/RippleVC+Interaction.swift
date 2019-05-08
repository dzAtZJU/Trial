//
//  RippleVC+Interaction.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

extension RippleVC: UIScrollViewDelegate, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath
        let action = rippleViewStore.state.scene == .watching ? RippleViewState.SceneAction.fullScreen : RippleViewState.SceneAction.surf
        rippleViewStore.dispatch(action)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inFocusCell?.unMountVideo()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard rippleViewStore.state.scene == .watching else {
            return
        }
        
        /// TODO: where to maintain centerItem
        fetchVideoForItem(layout.centerItem) { video in
            self.inFocusCell?.mountVideo(video)
        }
        
        preFetchVideoForTwoNeighborItems()
    }
    
    @objc func handlePinch(_ press: UIPinchGestureRecognizer) {
        guard rippleViewStore.state.scene == .watching else {
            return
        }
        
        switch press.state {
        case .began:
            rippleViewStore.dispatch(RippleViewState.SceneAction.surf)
        default:
            return
        }
        return
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .exitFullscreen:
            rippleViewStore.dispatch(RippleViewState.SceneAction.fullScreen)
        case .goToEpisodesView:
            let episodesVC = EpisodesVC()
            self.present(episodesVC, animated: false, completion: nil)
            return
        default:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layout.viewPortCenterChanged()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if rippleViewStore.state.scene == .full {
            return .landscape
        }
        if preSceneState == .full {
            return .all
        }
        return .allButUpsideDown
    }
}
