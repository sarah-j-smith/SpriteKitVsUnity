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
    func activate(node: SKNode)
    {
        let e = entities.first { (ent: GKEntity) -> Bool in
            ent.sprite == node
        }
        let c = e?.component(ofType: MultiStateObject.self)
        c?.mobState?.enter(ActiveState.self)
        
        print("Activated \(c)")
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        print("contact: \(contact.bodyA.node?.name ?? "unnamed") - \(contact.bodyB.node?.name ?? "unnamed")")
        if contact.bodyA.node?.userData?.object(forKey: "Chest") != nil
        {
            activate(node: contact.bodyA.node!)
        }
        if contact.bodyB.node?.userData?.object(forKey: "Chest") != nil
        {
            activate(node: contact.bodyB.node!)
        }
    }
}
