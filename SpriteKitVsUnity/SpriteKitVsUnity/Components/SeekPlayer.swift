//
//  SeekPlayer.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 10/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit


class SeekPlayer: GKComponent, Loadable, GKAgentDelegate
{
    @GKInspectable var speed: Float = 100.0
    @GKInspectable var mass: Float = 0.01
    @GKInspectable var acceleration: Float = 1000.0
    
    var playerInitialised = false
    
    func wasLoaded(into scene: SKScene)
    {
        guard let spr = entity?.sprite else { return }
        
        guard let actualPhysicsBody = entity?.sprite?.physicsBody else {
            print("Enable a physics body to make this component work")
            return
        }
        actualPhysicsBody.categoryBitMask = PhysicsCategory.Zombie
        actualPhysicsBody.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Barrier
        actualPhysicsBody.contactTestBitMask = PhysicsCategory.All
        
        let agent = GKAgent2D()
        entity?.addComponent(agent)
        agent.delegate = self
        agent.position = float2(x: Float(spr.position.x), y: Float(spr.position.y))
        
        guard let entities = (scene as? GameplayScene)?.entities else { return }
        for e in entities
        {
            if e.component(ofType: PlayerMove.self) != nil
            {
                if let playerAgent = e.component(ofType: GKAgent2D.self)
                {
                    chase(targetAgent: playerAgent)
                }
            }
        }
        
        agent.mass = mass
        agent.maxSpeed = speed
        agent.maxAcceleration = acceleration
    }
    
    func chase(targetAgent: GKAgent2D)
    {
        if playerInitialised { return }
        if let agent = entity?.component(ofType: GKAgent2D.self), let spr = entity?.sprite
        {
            agent.behavior = GKBehavior(goal: GKGoal(toSeekAgent: targetAgent), weight: 1.0)
            playerInitialised = true
            print("Set \(spr.name!) at \(agent.position) to chase player \(targetAgent.position)")
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
