//
//  EpisodesLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class EpisodesLayout: UICollectionViewFlowLayout {
    
    var sceneState: EpisodesSceneState
    
    static let sliding = EpisodesLayout(sceneState: .sliding, size: CGSize(width: 120, height: 225))
    
    static let watching = EpisodesLayout(sceneState: .watching, size:  CGSize(width: 250, height: 225))
    
    static let watching2Full = EpisodesLayout(sceneState: .watching2Full, size:  CGSize(width: 432, height: 243))
    
    static let full = EpisodesLayout(sceneState: .full, size: CGSize(width: 667, height: 375))
    
    static let full2Watching = EpisodesLayout(sceneState: .full2Watching, size: CGSize(width: 518, height: 292))
    
    private init(sceneState: EpisodesSceneState) {
        self.sceneState = sceneState
        super.init()
        scrollDirection = .horizontal
    }
    
    private init(sceneState: EpisodesSceneState, size: CGSize) {
        self.sceneState = sceneState
        super.init()
        scrollDirection = .horizontal
        itemSize = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let result = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let latestWatchItem = (collectionView?.delegate as? EpisodesVC)?.model.latestWatchItem
        
        for attributes in result {
            let attributes = attributes as! EpisodeLayoutAttributes
            attributes.radius = 8
            switch sceneState {
            case .sliding:
                attributes.hideContent = true
            case .watching, .full:
                guard attributes.indexPath == latestWatchItem else {
                    continue
                }
                attributes.radius = 14
                attributes.hideContent = false
            default:
                continue
            }
        }
        
        return result
    }
    
    override class var layoutAttributesClass: AnyClass {
        return EpisodeLayoutAttributes.classForCoder()
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let vc = collectionView?.delegate as? EpisodesVC, let attributes = layoutAttributesForItem(at: vc.model.latestWatchItem ) {
            return attributes.frame.center - CGRect(origin: .zero, size: collectionView!.frame.size).center
        }

        return proposedContentOffset
    }
}
