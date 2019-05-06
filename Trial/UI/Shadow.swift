//
//  TransitionalLayer.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/18.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class Shadow: UIImageView, TransitionalResource {
    
    static var surf = Shadow(image: UIImage(named: "shadow_surfing"))
    
    static var watch = Shadow(image: UIImage(named: "shadow_landing"))
    
    static var surfLand = Shadow(image: UIImage(named: "land_shadow_surfing"))
    
    static var watchLand = Shadow(image: UIImage(named: "land_shadow_landing"))
    
    static var dumb = Shadow()
    
    typealias Item = Shadow
    
    func nextOnScene() -> Shadow {
        switch self {
        case .surf:
            return .watch
        case .watch:
            return .surf
        case .surfLand:
            return .watchLand
        case .watchLand:
            return .surfLand
        case .dumb:
                return .watch
        default:
            fatalError("")
        }
    }
    
    func nextOnRotate() -> Shadow {
        switch self {
        case .surf:
            return .surfLand
        case .watch:
            return .watchLand
        case .surfLand:
            return .surf
        case .watchLand:
            return .watch
        default:
            fatalError("")
        }
    }
    
    func nextOnExit(isPortrait: Bool) -> Shadow {
        if isPortrait {
            return .watch
        }
        
        return .watchLand
    }
    
    override var description: String {
        switch self {
        case .surf:
            return "surf"
        case .watch:
            return "watch"
        case .surfLand:
            return "surfLand"
        case .watchLand:
            return "watchLand"
        case .dumb:
            return "dumb"
        default:
            fatalError("")
        }
    }
}
