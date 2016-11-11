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

    private func loadAction(actionName: String) -> SKAction?
    {
        if let act = SKAction(named: actionName)
        {
            return act
        }
        let name = entity?.sprite?.name ?? "Unnamed sprite"
        print("Could not load action \(actionName) for \(name)")
        return nil
    }
    
    func wasLoaded(into scene: SKScene)
    {
        guard let spriteNode = entity?.sprite else {
            print("Attach this component to a sprite node")
            return
        }
        var animStates = [ AnimationState ]()
        if let idleAnim = loadAction(actionName: idleAnimation)
        {
            let idle = IdleState(stateName: idleAnimation, node: spriteNode)
            idle.animation = idleAnim
            animStates.append(idle)
        }
        if let moveAnim = loadAction(actionName: moveAnimation)
        {
            let move = MoveState(stateName: moveAnimation, node: spriteNode)
            move.animation = moveAnim
            animStates.append(move)
        }
        if let attackAnim = loadAction(actionName: attackAnimation)
        {
            let attack = AttackState(stateName: attackAnimation, node: spriteNode)
            attack.animation = attackAnim
            animStates.append(attack)
        }
        if let dieAnim = loadAction(actionName: dieAnimation)
        {
            let die = DyingState(stateName: dieAnimation, node: spriteNode)
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
        
        var v = actualPhysicsBody.velocity
        if let enemyAI = entity?.component(ofType: ZombieEnemy.self)
        {
            v = enemyAI.velocity
        }
        if fabsf(Float(v.dx)) < 3.0 && fabsf(Float(v.dy)) < 3.0
        {
            actualPhysicsBody.velocity = CGVector.zero
            mobState?.enter(IdleState.self)
        }
        else
        {
            mobState?.enter(MoveState.self)
        }
        let flipScale = (v.dx > 0.0) ? 1.0 : -1.0
        entity?.sprite?.xScale = CGFloat(flipScale)
    }
}
