//
//  EpisodesVC1+Data.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

let seasonsNum = 3

extension EpisodesVC: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func prepareForPresent() {
        pageDataManager.genesisLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == episodesView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episode", for: indexPath) as! EpisodeCell
            cell.episodeNum.text = (indexPath.row + 1).description
            pageDataManager.batchRequest([indexPath])
            pageDataManager.get(indexPath) { data in
                DispatchQueue.main.async {
                    cell.thumbnailView.image = data.thumbnail
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
        
        return pageDataManager.seasonsNum
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == seasonsView {
            return pageDataManager.seasonsNum
        }
        
        return pageDataManager.episodesNums[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        pageDataManager.batchRequest(indexPaths)
        for item in indexPaths {
            pageDataManager.request(item)
        }
    }
}
