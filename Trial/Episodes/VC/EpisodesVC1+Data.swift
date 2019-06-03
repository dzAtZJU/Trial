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

extension EpisodesVC: UICollectionViewDataSource {
    func prepareForPresent(inFocusItem: IndexPath, transferredVideo: VideoWithPlayerView) {
        self.inFocusItem = inFocusItem
        self.inFocusVideo = transferredVideo
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == episodesView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episode", for: indexPath) as! EpisodeCell
            cell.episodeNum.text = (indexPath.row + 1).description
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
        
        return seasonsNum
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == seasonsView {
            return seasonsNum
        }
        
        return 10
    }
}
