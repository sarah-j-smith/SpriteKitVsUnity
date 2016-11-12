//
//  HealthTracked.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 12/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import GameplayKit
import SpriteKit

class HealthTracked : GKComponent
{
    @GKInspectable var health: Float = 80.0
    
    private var damageRates = [ Float ]()
    
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
    
    override func update(deltaTime seconds: TimeInterval)
    {
        if !damageRates.isEmpty
        {
            var damage: Float = 0
            for d in damageRates { damage += d }
            damage = damage * Float(seconds)
            
            health -= damage
            if health < 0.0
            {
                entity?.component(ofType: MobState.self)?.mobState?.enter(DyingState.self)
            }
        }
    }
    
    
}
