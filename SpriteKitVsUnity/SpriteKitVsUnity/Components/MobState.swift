//
//  MobState.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 11/7/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import Foundation
import GameplayKit

class MoveState: AnimationState
{
    init(_ handler: @escaping StateAnimationHandler) {
        super.init(stateName: "Move", handler)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == IdleState.self
    }
}

class IdleState: AnimationState
{
    init(_ handler: @escaping StateAnimationHandler) {
        super.init(stateName: "Idle", handler)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == MoveState.self
    }
}

class AttackState: AnimationState
{
    init(_ handler: @escaping StateAnimationHandler) {
        super.init(stateName: "Attack", handler)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == MoveState.self
    }
}

class DyingState: AnimationState
{
    init(_ handler: @escaping StateAnimationHandler) {
        super.init(stateName: "Dying", handler)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == MoveState.self
    }
}

class MobState: GKComponent, Loadable
{
    var mobState: GKStateMachine?
    
    @GKInspectable var idleAnimation: String = "Idle"
    @GKInspectable var moveAnimation: String = "Move"
    @GKInspectable var attackAnimation: String = "Attack"
    @GKInspectable var dieAnimation: String = "Die"

    func wasLoaded(into scene: SKScene)
    {
        guard let spriteNode = entity?.sprite else {
            print("Attach this component to a sprite node")
            return
        }
        var animStates = [ AnimationState ]()
        if let idleAnim = SKAction(named: idleAnimation)
        {
            let idle = IdleState() {
                spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
                spriteNode.run(idleAnim, withKey: MobState.ANIMATION_KEY)
            }
            animStates.append(idle)
        }
        if let moveAnim = SKAction(named: moveAnimation)
        {
            let move = IdleState() {
                spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
                spriteNode.run(moveAnim, withKey: MobState.ANIMATION_KEY)
            }
            animStates.append(move)
        }
        if let idleAnim = SKAction(named: self.idleAnimation)
        {
            let idle = IdleState() {
                spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
                spriteNode.run(idleAnim, withKey: MobState.ANIMATION_KEY)
            }
            animStates.append(idle)
        }
        if let idleAnim = SKAction(named: self.idleAnimation)
        {
            let idle = IdleState() {
                spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
                spriteNode.run(idleAnim, withKey: MobState.ANIMATION_KEY)
            }
            animStates.append(idle)
        }
        print("Assigned mobile character state machine to \(spriteNode.name!)")
        mobState = GKStateMachine(states: animStates)
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
