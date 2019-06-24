//
//  EpisodesVC1+Data.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

let seasonsNum = 3

var transferVideoId: VideoId!
var transferEpisode: IndexPath!

extension EpisodesVC: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func prepareForPresent(programId: String, episode: IndexPath, scene: EpisodesSceneState, completion: () -> ()) {
        try! EpisodesDataManager.load(programId: programId) { pageDataManager in
            let store = Store(reducer: EpisodesViewState.appReducer, state: EpisodesViewState(scene: scene))
            model = EpisodesVCModel(pageDataManager: pageDataManager, viewStore: store, latestWatchItem: episode)
            completion()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == episodesView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episode", for: indexPath) as! EpisodeCell
            cell.episodeNum.text = (indexPath.row + 1).description
            model.pageDataManager.batchRequest([indexPath])
            model.pageDataManager.get(indexPath) { data in
                DispatchQueue.main.async {
                    cell.thumbnailView.image = data.thumbnail
                    cell.title = data.title
                }
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "season", for: indexPath) as! SeasonCell
        cell.setSeasonNum(indexPath.row + 1)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == seasonsView {
            return 1
        }
        
        return model.pageDataManager.seasonsNum
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == seasonsView {
            return model.pageDataManager.seasonsNum
        }
        
        return model.pageDataManager.episodesNums[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        model.pageDataManager.batchRequest(indexPaths)
        for item in indexPaths {
            model.pageDataManager.request(item)
        }
    }
}
