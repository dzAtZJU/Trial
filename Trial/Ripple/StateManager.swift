//
//  StateManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/26.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var scene = SceneState.initial
}

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(scene: sceneReducer(action: action, state: state?.scene))
}

func sceneReducer(action: Action, state: SceneState?) -> SceneState {
    let scene = state ?? SceneState.initial
    
    guard case is SceneAction  = action else {
        return scene
    }
    
    switch action as! SceneAction {
        case .touchCell:
            switch state! {
                case .surfing:
                    return  .watching
                case .watching:
                    return .full
                case .full:
                    return .full2Watching
                default:
                    return scene
            }
        case .exitFullScreen:
            return .full2Watching
        case .exitFullScreenCompleted:
            switch state! {
                case .full2Watching:
                    return .watching
            case .surf2Watching:
                    return  .surfing
                default:
                    return scene
            }
        case .press:
            switch state! {
                case .watching:
                    return .surfing
                case .surfing:
                    return .watching
                default:
                    return scene
            }
    }
}

let store = Store(reducer: appReducer, state: AppState())

indirect enum SceneAction: Action {
    case touchCell
    case exitFullScreen
    case exitFullScreenCompleted
    case press
}
