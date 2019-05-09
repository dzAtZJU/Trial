//
//  EpisodesLayout.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

protocol InFocusItemManager {
    var inFocusItem: IndexPath! { get }
}

class EpisodesLayout: UICollectionViewFlowLayout {
    
    var sceneState: EpisodesSceneState

//    static let sliding = EpisodesLayout(sceneState: .sliding)
//    static let watching = EpisodesLayout(sceneState: .watching)
//    static let full = EpisodesLayout(sceneState: .full)
//    static let watching2Full = EpisodesLayout(sceneState: .watching2Full)
//    static let full2Watching = EpisodesLayout(sceneState: .full2Watching)
    
    static let sliding = EpisodesLayout(sceneState: .sliding, size: CGSize(width: 120, height: 225))
    static let watching = EpisodesLayout(sceneState: .watching, size:  CGSize(width: 432, height: 243))
    static let full = EpisodesLayout(sceneState: .full, size: CGSize(width: 667, height: 375))
    static let watching2Full = EpisodesLayout(sceneState: .watching2Full, size:  CGSize(width: 432, height: 243))
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
        
        let inFocusItem = (collectionView?.delegate as? InFocusItemManager)?.inFocusItem
        
        for attributes in result {
            (attributes as! EpisodeLayoutAttributes).radius = 8
            if attributes.indexPath == inFocusItem {
                switch sceneState {
                case .watching:
                    (attributes as! EpisodeLayoutAttributes).radius = 14
                default:
                    continue
                }
            }
        }
        
        return result
    }
    
    override class var layoutAttributesClass: AnyClass {
        return EpisodeLayoutAttributes.classForCoder()
    }
//    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
//
//    }
//
//    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
//
//    }
//
//
//    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let ori = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
//        let real = layoutAttributesForItem(at: itemIndexPath)
//        if sceneState == .watching {
//            print("initial -- \(itemIndexPath): \(ori?.frame)")
//            print("initial \(itemIndexPath): \(real?.frame)")
//            print("------")
//        }
//
//
//        return ori
//    }
//
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let item = (collectionView?.delegate as? InFocusItemManager)?.inFocusItem, let attributes = layoutAttributesForItem(at: item) {
            print("before: \(item) \(attributes.frame)")
            return attributes.frame.center - collectionView!.frame.center
        }

        return proposedContentOffset
    }
}
