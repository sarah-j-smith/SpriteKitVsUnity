//
//  GameplayScene+Physics.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 10/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameplayScene: SKPhysicsContactDelegate
{
    func activate(entityA: GKEntity, entityB: GKEntity)
    {
        if let gameObject = entityA.component(ofType: MultiStateObject.self)
        {
            gameObject.multiState?.enter(ActiveState.self)
        }
        if let zombie = entityA.component(ofType: ZombieEnemy.self),
            let player = entityB.component(ofType: PlayerMove.self)
        {
            let mob = entityA.component(ofType: MobState.self)!.mobState!
            mob.enter(AttackState.self)
            player.takeDamage(dps: zombie.dps)
        }
        if let zombie = entityB.component(ofType: ZombieEnemy.self),
            let player = entityA.component(ofType: PlayerMove.self)
        {
            let mob = entityB.component(ofType: MobState.self)!.mobState!
            mob.enter(AttackState.self)
            player.takeDamage(dps: zombie.dps)
        }
    }

    func deactivate(entityA: GKEntity, entityB: GKEntity)
    {
        if let zombie = entityA.component(ofType: ZombieEnemy.self),
            let player = entityB.component(ofType: PlayerMove.self)
        {
            let mob = entityA.component(ofType: MobState.self)!.mobState!
            mob.enter(IdleState.self)
            entityA.component(ofType: MobState.self)?.mobState?.enter(AttackState.self)
            player.ceaseDamage(dps: zombie.dps)
        }
        if let zombie = entityB.component(ofType: ZombieEnemy.self),
            let player = entityA.component(ofType: PlayerMove.self)
        {
            let mob = entityB.component(ofType: MobState.self)!.mobState!
            mob.enter(IdleState.self)
            entityB.component(ofType: MobState.self)?.mobState?.enter(AttackState.self)
            player.ceaseDamage(dps: zombie.dps)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        print("contact: \(contact.bodyA.node?.name ?? "unnamed") - \(contact.bodyB.node?.name ?? "unnamed")")
        if let bodyAEntity = contact.bodyA.node?.nodeEntity, let bodyBEntity = contact.bodyB.node?.nodeEntity
        {
            activate(entityA: bodyAEntity, entityB: bodyBEntity)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("seperate: \(contact.bodyA.node?.name ?? "unnamed") - \(contact.bodyB.node?.name ?? "unnamed")")
        if let bodyAEntity = contact.bodyA.node?.nodeEntity, let bodyBEntity = contact.bodyB.node?.nodeEntity
        {
            deactivate(entityA: bodyAEntity, entityB: bodyBEntity)
        }
    }
}
