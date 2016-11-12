//
//  MoveWithTouch.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 12/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import GameplayKit
import SpriteKit

class MoveWithTouch : GKComponent, Touchable
{
    @GKInspectable var mobSpeed: Float = 280.0
    
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
        let newVelocity = pt.normalized() * CGFloat(mobSpeed)
        
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
