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
        return stateClass == MoveState.self
    }
}

class ActiveState: AnimationState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == MoveState.self
    }
}

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
        let idle = IdleState(stateName: "Idle") {
            spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
            spriteNode.run(SKAction(named: self.baseAnimation)!, withKey: MobState.ANIMATION_KEY)
        }
        let move = MoveState(stateName: "Move") {
            spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
            spriteNode.run(SKAction(named: self.activeAnimation)!, withKey: MobState.ANIMATION_KEY)
        }
        print("Assigned mobile character state machine to \(spriteNode.name!)")
        mobState = GKStateMachine(states: [ idle, move ])
        mobState?.enter(IdleState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval)
    {
        guard let actualPhysicsBody = entity?.sprite?.physicsBody else {
            print("Enable a physics body to make this component work")
            return
        }
        
        let v = actualPhysicsBody.velocity
        if fabsf(Float(v.dx)) < 3.0 && fabsf(Float(v.dy)) < 3.0
        {
            actualPhysicsBody.velocity = CGVector.zero
            mobState?.enter(IdleState.self)
        }
        else
        {
            let flipScale = (actualPhysicsBody.velocity.dx > 0.0) ? 1.0 : -1.0
            entity?.sprite?.xScale = CGFloat(flipScale)
            mobState?.enter(MoveState.self)
        }
    }
}
