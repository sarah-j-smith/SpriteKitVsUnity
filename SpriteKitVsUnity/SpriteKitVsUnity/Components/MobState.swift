//
//  MobState.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 11/7/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import Foundation
import GameplayKit

typealias StateAnimationHandler = () -> Void

class MoveState: GKState
{
    let moveAnimHandler: StateAnimationHandler

    init(_ enterHandler: @escaping StateAnimationHandler) {
        moveAnimHandler = enterHandler
    }
    
    override func didEnter(from previousState: GKState?) {
        print("entering move state")
        moveAnimHandler()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == IdleState.self
    }
}

class IdleState: GKState
{
    let moveAnimHandler: StateAnimationHandler
    
    init(_ enterHandler: @escaping StateAnimationHandler) {
        moveAnimHandler = enterHandler
    }
    
    override func didEnter(from previousState: GKState?) {
        print("entering idle state")
        moveAnimHandler()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == MoveState.self
    }
}

class MobState: GKComponent, Loadable
{
    var mobState: GKStateMachine?
    
    static let ANIMATION_KEY = "StateAnimation"
    
    @GKInspectable var idleAnimation: String = "Idle"
    @GKInspectable var moveAnimation: String = "Move"
    
    func wasLoaded(into scene: SKScene) {
        guard let spriteNode = entity?.sprite else {
            print("Attach this component to a sprite node")
            return
        }
        let idle = IdleState {
            spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
            let idle = SKAction(named: self.idleAnimation)!
            spriteNode.run(SKAction.repeatForever(idle), withKey: MobState.ANIMATION_KEY)
        }
        let move = MoveState {
            spriteNode.removeAction(forKey: MobState.ANIMATION_KEY)
            let move = SKAction(named: self.moveAnimation)!
            spriteNode.run(SKAction.repeatForever(move), withKey: MobState.ANIMATION_KEY)
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
