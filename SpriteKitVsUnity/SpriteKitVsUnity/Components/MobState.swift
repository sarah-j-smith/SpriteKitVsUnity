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
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == IdleState.self || stateClass == AttackState.self || stateClass == DyingState.self
    }
}

class IdleState: AnimationState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == MoveState.self || stateClass == AttackState.self || stateClass == DyingState.self
    }
}

class AttackState: AnimationState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == MoveState.self || stateClass == IdleState.self || stateClass == DyingState.self
    }
}

class DyingState: AnimationState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == MoveState.self || stateClass == IdleState.self || stateClass == AttackState.self
    }
}

/** A component that changes a mobile character sprite between up to 4 different animation actions.  
    If idleAnimation and moveAnimation are set then the sprite will change between these depending 
    on its velocity. */
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
            let idle = IdleState(stateName: idleAnimation, node: spriteNode)
            idle.animation = idleAnim
            animStates.append(idle)
        }
        if let moveAnim = SKAction(named: moveAnimation)
        {
            let move = MoveState(stateName: moveAnimation, node: spriteNode)
            move.animation = moveAnim
            animStates.append(move)
        }
        if let attackAnim = SKAction(named: attackAnimation)
        {
            let attack = AttackState(stateName: attackAnimation, node: spriteNode)
            attack.animation = attackAnim
            animStates.append(attack)
        }
        if let dieAnim = SKAction(named: dieAnimation)
        {
            let die = AttackState(stateName: dieAnimation, node: spriteNode)
            die.animation = dieAnim
            animStates.append(die)
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
        guard let currentState = mobState?.currentState else { return }
        if currentState.isKind(of: AttackState.self) || currentState.isKind(of: DyingState.self) { return }
        
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
