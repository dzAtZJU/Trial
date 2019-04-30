//
//  VideoContainer.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/22.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

protocol VideoContainer {
    func handleUserEnter(video: VideoWithPlayerView)
    func handleUserLeave()
}
