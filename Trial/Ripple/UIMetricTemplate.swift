//
//  Templates.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/4.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class UIMetricTemplate {
//    static var current: UIMetricTemplate {
//        switch sceneState {
//            case .surfing: return surf
//            case .watching: return watch
//            default: return watch
//        }
//    }
    
    func transformForCenterItemTo(_ newTemplate: UIMetricTemplate) -> CGAffineTransform {
        return CGAffineTransform(scaleX: newTemplate.itemWidth * newTemplate.scale / (itemWidth * scale), y: newTemplate.itemHeight * newTemplate.scale / (itemHeight * scale))
    }
    
    static let watch: UIMetricTemplate = {
        var template = UIMetricTemplate()
        template.rowGaps = [30, 25, 20]
        template.colGaps = [[15, 20], [25, 20], [25, 15]]
        template.itemWidth = 265
        template.itemHeight = 151
        template.scale = 1.188
        
        template.titlesBottom = 19
        template.titlesSpace = 0
        template.titleFontSize = 26
        template.subtitleFontSize = 16
        template.radius = 14
        return template
    }()
    
    static let surf: UIMetricTemplate = {
        var template = UIMetricTemplate()
        template.rowGaps = [30, 25, 20]
        template.colGaps = [[20, 20], [25, 20], [20, 15], [15, 15]]
        template.itemWidth = 157
        template.itemHeight = 89
        template.scale = 1.178
        
        template.titlesBottom = 12
        template.titlesSpace = 0
        template.titleFontSize = 18
        template.subtitleFontSize = 11
        template.radius = 6
        return template
    }()
    
    static let watchLand: UIMetricTemplate = {
        var template = UIMetricTemplate()
        template.rowGaps = [35]
        template.colGaps = [[35]]
        template.itemWidth = 400
        template.itemHeight = 225
        template.scale = 1.08
        template.radius = 14
        
        template.titlesBottom = 30
        template.titlesSpace = 0
        template.titleFontSize = 26
        template.subtitleFontSize = 16
        
        return template
    }()
    
    static let surfLand: UIMetricTemplate = {
        var template = UIMetricTemplate()
        template.rowGaps = [30]
        template.colGaps = [[25, 20]]
        template.itemWidth = 157
        template.itemHeight = 89
        template.scale = 1.08
        template.radius = 6
        
        template.titlesBottom = 12
        template.titlesSpace = 0
        template.titleFontSize = 18
        template.subtitleFontSize = 11
        return template
    }()
    
    static let watching2Full: UIMetricTemplate = {
        var template = UIMetricTemplate()
        template.itemWidth = 400
        template.itemHeight = 225
        template.rowGaps = [100]
        template.colGaps = [[100]]
        return template
    }()
    
    static let full: UIMetricTemplate = {
        var template = UIMetricTemplate()
        template.itemWidth = 667
        template.itemHeight = 375
        template.scale = 1
        template.rowGaps = [5000]
        template.colGaps = [[5000]]
        return template
    }()
    
    func toggled() -> UIMetricTemplate {
        if self === UIMetricTemplate.watch {
            return .surf
        } else {
            return .watch
        }
    }
    
    var rowGaps = [CGFloat]()
    var colGaps = [[CGFloat]]()
    var itemHeight: CGFloat = 0
    var itemWidth: CGFloat = 0
    var scale: CGFloat = 0
    var radius: CGFloat = 0
    
    var titlesBottom: CGFloat = 0
    var titlesSpace: CGFloat = 0
    var titleFontSize:CGFloat = 0
    var subtitleFontSize: CGFloat = 0
}
