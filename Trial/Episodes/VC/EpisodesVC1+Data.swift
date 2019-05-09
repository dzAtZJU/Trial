//
//  EpisodesVC1+Data.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

extension EpisodesVC {
    func prepareForPresent(inFocusItem: IndexPath, transferredVideo: VideoWithPlayerView) {
        self.inFocusItem = inFocusItem
        self.transferredVideo = transferredVideo
    }
}
