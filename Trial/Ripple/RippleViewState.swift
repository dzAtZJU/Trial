//
//  StateManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/26.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import ReSwift

struct RippleViewState: StateType {
    var scene = RippleSceneState.watching
    
    static func appReducer(action: Action, state: RippleViewState?) -> RippleViewState {
        return RippleViewState(scene: sceneReducer(action: action, state: state?.scene))
    }
    
    static func sceneReducer(action: Action, state: RippleSceneState?) -> RippleSceneState {
        let scene = state ?? RippleSceneState.watching
        
        guard case is SceneAction  = action else {
            return scene
        }
        
        switch action as! SceneAction {
        case .fullScreen:
            switch state! {
            case .watching:
                return .full
            case .full:
                return .watching
            default:
                fatalError()
            }
        case .stagedFullScreen:
            switch state! {
            case .watching:
                return .watching2Full
            case .watching2Full:
                return .full
            case .full:
                return .full2Watching
            case .full2Watching:
                return .watching
            default:
                fatalError()
            }
        case .surf:
            switch state! {
            case .watching:
                return .surfing
            case .surfing:
                return .watching
            default:
                fatalError()
            }
        default:
            fatalError()
        }
    }
    
    indirect enum SceneAction: Action {
        case fullScreen
        case stagedFullScreen
        case surf
    }
}

enum RippleSceneState: StateType {
    case surfing
    case watching
    case watching2Full
    case full
    case full2Watching
}

let rippleViewStore = Store(reducer: RippleViewState.appReducer, state: RippleViewState())


