//
//  PageDataManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/4.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class PageDataManager {
    private let item2VideoId = [IndexPath:VideoId]()
    
    private let youtubeManager = YoutubeManager.shared
    
    func requestFor(item: IndexPath, completion: ((YoutubeVideoData) -> ())? = nil) {
        
    }
}
