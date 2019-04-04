//
//  Templates.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/4.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics

struct UITemplates {
    
    static var current: UITemplates {
        switch sceneState {
            case .surfing: return surf
            case .watching: return watch
            default: return watch
        }
    }
    
    static let watch: UITemplates = {
        var template = UITemplates()
        template.titlesBottom = 19
        template.titlesSpace = 0
        template.titleFontSize = 26
        template.subtitleFontSize = 16
        template.rowGaps = [30, 25, 20]
        template.colGaps = [[15, 20], [25, 20], [25, 15]]
        template.itemWidth = 151
        template.itemHeight = 265
        template.scale = 1.188
        return template
    }()
    
    static let surf: UITemplates = {
        var template = UITemplates()
        template.titlesBottom = 19
        template.titlesSpace = 0
        template.titleFontSize = 26
        template.subtitleFontSize = 16
        template.rowGaps = [30, 25, 20]
        template.colGaps = [[20, 20], [25, 20], [20, 15], [15, 15]]
        template.itemWidth = 157
        template.itemHeight = 89
        template.scale = 1.178
        return template
    }()
    
    var rowGaps = [CGFloat]()
    var colGaps = [[CGFloat]]()
    var itemHeight: CGFloat = 0
    var itemWidth: CGFloat = 0
    var scale: CGFloat = 0
    
    var titlesBottom: CGFloat = 0
    var titlesSpace: CGFloat = 0
    var titleFontSize:CGFloat = 0
    var subtitleFontSize:CGFloat = 0
    
    
//
//    let scale: CGFloat = 1.2
//
//    let itemHeight: CGFloat = 100
//    let rowGaps: [CGFloat] = [30, 25, 20]
//
//    let itemWidth: CGFloat = 150
//    let colGaps: [[CGFloat]] = [[25, 20], [20, 20], [15, 15]]
//
//    let itemWidthForWatching = itemWidth * 1.8
//    let itemHeightForWatching = itemHeight * 1.8
}
