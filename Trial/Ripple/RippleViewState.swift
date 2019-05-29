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
    
    var ready = false
    
    static func appReducer(action: Action, state: RippleViewState?) -> RippleViewState {
        return RippleViewState(scene: sceneReducer(action: action, state: state?.scene), ready: readyReducer(action: action, state: state?.ready))
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
    
    static func readyReducer(action: Action, state: Bool?) -> Bool {
        let state = state ?? false
        
        guard case is ReadyAction = action else {
            return state
        }
        
        return true
    }
        
    indirect enum SceneAction: Action {
        case fullScreen
        case surf
        case ready
    }
    
    indirect enum ReadyAction: Action {
        case ready
    }
}

enum RippleSceneState: StateType {
    case surfing
    case watching
    case full
}

let rippleViewStore = Store(reducer: RippleViewState.appReducer, state: RippleViewState())


