//
//  Treasure.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 10/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit

class Treasure: GKComponent, Loadable, Activatable
{
    @GKInspectable var bullets: Int = 5
    @GKInspectable var health: Int = 5
    @GKInspectable var points: Int = 10
    
    static let TREASURE_NOTIFICATION = NSNotification.Name(rawValue: "TreasureActivation")
    
    func wasLoaded(into scene: SKScene)
    {
        guard let spr = entity?.sprite else { return }
        spr.nodeEntity = entity
        spr.userData?["CHEST"] = 1
        
        guard let actualPhysicsBody = spr.physicsBody else {
            print("Enable a physics body to make this component work")
            return
        }
        print("Loaded a treasure chest - bullets: \(bullets) - health: \(health) - points: \(points)")
        actualPhysicsBody.categoryBitMask = PhysicsCategory.Treasure
        actualPhysicsBody.collisionBitMask = PhysicsCategory.None
        actualPhysicsBody.contactTestBitMask = PhysicsCategory.Player
    }
    
    func activate()
    {
        NotificationCenter.default.post(name: Treasure.TREASURE_NOTIFICATION, object: nil, userInfo: [ "Bullets": bullets, "Health": health, "Points": points ])
    }
}
