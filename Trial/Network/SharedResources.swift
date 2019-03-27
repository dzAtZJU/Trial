//
//  SharedResources.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/27.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation

let YoutubeOperationQueue = OperationQueue()

let OperationName_YoutubeVideosThumbnailsUrls = "youtubeVideosThumbnailsUrls"

func findOperatoinByName(_ name: String, in queue: OperationQueue) -> Operation? {
    return queue.operations.first(where: { $0.name == name })
}
