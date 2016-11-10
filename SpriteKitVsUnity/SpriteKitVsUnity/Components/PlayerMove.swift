//
//  Player.swift
//  PestControl
//
//  Created by Sarah Smith on 11/5/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayerMove : GKComponent, Touchable
{
    @GKInspectable var playerSpeed: Float = 280.0
    
    private var targetPoint = CGPoint.zero
    
    var priority: Int { return 9 }
    
    func wasTriggered(worldPoint point: CGPoint) -> Bool
    {
        move(target: point)
        return true
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
        
//        print("target: \(target) pos: \(spriteNode.position)")
//        print("velocity: \(CGVector(point: newVelocity))")
        
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
}
