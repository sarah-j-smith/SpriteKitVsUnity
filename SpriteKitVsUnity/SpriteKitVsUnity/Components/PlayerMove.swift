//
//  Player.swift
//  PestControl
//
//  Created by Sarah Smith on 11/5/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayerMove : GKComponent, Loadable, Touchable, GKAgentDelegate
{
    @GKInspectable var playerSpeed: Float = 280.0
    
    private var targetPoint = CGPoint.zero
    
    var priority: Int { return 9 }
    
    func wasTriggered(worldPoint point: CGPoint) -> Bool
    {
        move(target: point)
        return true
    }
    
    func wasLoaded(into scene: SKScene)
    {
        guard let spr = entity?.sprite else { return }
        
        guard let actualPhysicsBody = entity?.sprite?.physicsBody else {
            print("Enable a physics body to make this component work")
            return
        }
        actualPhysicsBody.categoryBitMask = PhysicsCategory.Player
        actualPhysicsBody.collisionBitMask = PhysicsCategory.Edge
        actualPhysicsBody.contactTestBitMask = PhysicsCategory.All
        
        let agent = GKAgent2D()
        entity?.addComponent(agent)
        agent.delegate = self
        agent.position = float2(x: Float(spr.position.x), y: Float(spr.position.y))
        agent.mass = 0.01
        agent.maxSpeed = 280.0
        agent.maxAcceleration = 1000.0
        
        if let entities = (scene as? GameplayScene)?.entities
        {
            for e in entities
            {
                if let seeker = e.component(ofType: SeekPlayer.self)
                {
                    seeker.chase(targetAgent: agent)
                }
            }
        }
    }
    
    func move(target: CGPoint)
    {
        guard let spriteNode = entity?.sprite else {
            print("Attach this component to a sprite node")
            return
        }
        guard let actualPhysicsBody = entity?.sprite?.physicsBody else {
            print("Enable a physics body to make this component work")
            return
        }
        let pt = target - spriteNode.position
        let newVelocity = pt.normalized() * CGFloat(playerSpeed)
        
        actualPhysicsBody.velocity = CGVector(point: newVelocity)
        targetPoint = target
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let spriteNode = entity?.sprite else {
            print("Attach this component to a sprite node")
            return
        }
        let dist = targetPoint.distanceTo(spriteNode.position)
        if dist < spriteNode.size.width/2
        {
            spriteNode.physicsBody?.velocity = CGVector.zero
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
