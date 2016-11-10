//
//  MultiStateObject.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 9/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import Foundation
import GameplayKit

class BaseState: AnimationState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ActiveState.self
    }
}

class ActiveState: AnimationState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == BaseState.self
    }
}

/** A component that can take on one of two states: a quiescent waiting state by default,
    and an activated state. */
class MultiStateObject: GKComponent, Loadable
{
    var mobState: GKStateMachine?
    
    static let ANIMATION_KEY = "StateAnimation"
    
    @GKInspectable var baseAnimation: String = "Base"
    @GKInspectable var activeAnimation: String = "Active"
    
    func wasLoaded(into scene: SKScene) {
        guard let spriteNode = entity?.sprite else {
            print("Attach this component to a sprite node")
            return
        }
        let base = BaseState(stateName: "Base", node: spriteNode)
        base.animation = SKAction(named: baseAnimation)
        let active = ActiveState(stateName: "Active", node: spriteNode)
        active.animation = SKAction(named: activeAnimation)
        print("Assigned multi-state machine to \(spriteNode.name!)")
        mobState = GKStateMachine(states: [ base, active ])
        mobState?.enter(BaseState.self)
    }
}
