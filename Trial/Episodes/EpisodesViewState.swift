//
//  StateManager.swift
//  Trial
//
//  Created by 周巍然 on 2019/4/26.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import ReSwift

struct EpisodesViewState: StateType {
    var scene = EpisodesSceneState.watching
    
    static func appReducer(action: Action, state: EpisodesViewState?) -> EpisodesViewState {
        return EpisodesViewState(scene: sceneReducer(action: action, state: state?.scene))
    }
    
    static func sceneReducer(action: Action, state: EpisodesSceneState?) -> EpisodesSceneState {
        let scene = state ?? EpisodesSceneState.watching
        
        guard case is SceneAction  = action else {
            return scene
        }
        
        switch action as! SceneAction {
        case .touchCell:
            switch scene {
            case .sliding:
                return .watching
            case .watching:
                return .full
            case .full:
                return .watching
            default:
                fatalError()
            }
        case .scroll:
            switch scene {
            case .sliding:
                return .watching
            case .watching:
                return .sliding
            default:
                fatalError()
            }
        }
    }
    
    indirect enum SceneAction: Action {
        case touchCell
        case scroll
    }
}

enum EpisodesSceneState {
    case sliding
    case watching
    case full
    case watching2Full
    case full2Watching
}

let episodesViewStore = Store(reducer: EpisodesViewState.appReducer, state: EpisodesViewState())
