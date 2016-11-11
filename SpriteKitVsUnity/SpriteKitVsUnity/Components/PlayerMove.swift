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
    @GKInspectable var playerHealth: Float = 80.0
    
    private var targetPoint = CGPoint.zero
    private var enemiesInitialised = false
    private var damageRates = [ Float ]()
    
    var priority: Int { return 9 }
    
    func wasTriggered(worldPoint point: CGPoint) -> Bool
    {
        move(target: point)
        return true
    }
    
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
    
    func takeDamage(dps: Float)
    {
        if damageRates.isEmpty
        {
            guard let spr = entity?.sprite else { return }
            let flashRed = SKAction.colorize(withColorBlendFactor: 1.0, duration: 0.4)
            let goNormal = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.4)
            let pulseUp = SKAction.scale(to: 1.2, duration: 0.4)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.4)
            let constantlyFlash = SKAction.repeatForever(SKAction.group([
                SKAction.sequence([flashRed, goNormal]),
                SKAction.sequence([pulseUp, pulseDown])
                ]))
            spr.run(constantlyFlash, withKey: "FlashRed")
        }
        damageRates.append(dps)
    }
    
    func ceaseDamage(dps: Float)
    {
        if let damageIx = damageRates.index(of: dps)
        {
            damageRates.remove(at: damageIx)
        }
        if damageRates.isEmpty
        {
            guard let spr = entity?.sprite else { return }
            spr.removeAction(forKey: "FlashRed")
            spr.colorBlendFactor = 0.0
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
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let spriteNode = entity?.sprite else {
            print("Attach this component to a sprite node")
            return
        }
        if !enemiesInitialised
        {
            enemiesInitialised = true
            initialiseEnemies()
        }
        let dist = targetPoint.distanceTo(spriteNode.position)
        if dist < spriteNode.size.width/2
        {
            spriteNode.physicsBody?.velocity = CGVector.zero
        }
        if !damageRates.isEmpty
        {
            var damage: Float = 0
            for d in damageRates { damage += d }
            damage = damage * Float(seconds)
            
            playerHealth -= damage
            if playerHealth < 0.0
            {
                entity?.component(ofType: MobState.self)?.mobState?.enter(DyingState.self)
            }
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
