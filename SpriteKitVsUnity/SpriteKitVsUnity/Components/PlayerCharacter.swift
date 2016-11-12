//
//  Player.swift
//  PestControl
//
//  Created by Sarah Smith on 11/5/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayerCharacter : GKComponent, Loadable, GKAgentDelegate
{
    private var enemiesInitialised = false
    
    func wasLoaded(into scene: SKScene)
    {
        guard let spr = entity?.sprite else { return }
        spr.nodeEntity = entity
        spr.userData?["PLAYER"] = 1

        spr.physicsBody = SKPhysicsBody(circleOfRadius: spr.size.width / 6.0)
        spr.physicsBody!.affectedByGravity = false
        spr.physicsBody!.allowsRotation = false
        spr.physicsBody!.categoryBitMask = PhysicsCategory.Player
        spr.physicsBody!.collisionBitMask = PhysicsCategory.Edge
        spr.physicsBody!.contactTestBitMask = PhysicsCategory.Zombie | PhysicsCategory.Treasure
        
        let agent = GKAgent2D()
        entity?.addComponent(agent)
        agent.delegate = self
        agent.position = float2(x: Float(spr.position.x), y: Float(spr.position.y))
        agent.mass = 0.01
        agent.maxSpeed = 280.0
        agent.maxAcceleration = 1000.0
    }
    
    /** Initialise all enemy behaviours that rely on this player agent. */
    private func initialiseEnemies()
    {
        guard let entities = (entity?.sprite?.scene as? GameplayScene)?.entities else { return }
        guard let playerAgent = entity?.component(ofType: GKAgent2D.self) else { return }
        for ent in entities
        {
            if ent == entity { continue }
            let enemy = ent.component(ofType: ZombieEnemy.self)
            enemy?.initialiseComponents(withPlayerAgent: playerAgent)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval)
    {
        if !enemiesInitialised
        {
            enemiesInitialised = true
            initialiseEnemies()
        }
    }

    func agentWillUpdate(_ agent: GKAgent)
    {
        if let agent = entity?.component(ofType: GKAgent2D.self), let spr = entity?.sprite
        {
            agent.position = float2(Float(spr.position.x), Float(spr.position.y))
        }
    }
    
    func agentDidUpdate(_ agent: GKAgent)
    {
        if let agent = entity?.component(ofType: GKAgent2D.self), let spr = entity?.sprite
        {
            spr.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
        }
    }

}
