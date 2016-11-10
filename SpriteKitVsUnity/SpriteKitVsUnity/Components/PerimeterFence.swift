//
//  PerimeterFence.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None:      UInt32 = 0
    static let All:       UInt32 = 0xFFFFFFFF
    static let Edge:      UInt32 = 0b1
    static let Player:    UInt32 = 0b10
    static let Treasure:  UInt32 = 0b100
    static let Zombie:    UInt32 = 0b1000
    static let Barrier:   UInt32 = 0b10000
}

class PerimeterFence: GKComponent, Loadable
{
    func wasLoaded(into inScene: SKScene)
    {
        guard let background = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return }
        if background.physicsBody != nil
        {
            print("Do not PerimeterFence component to a node that already has a physics body")
            return
        }
        print("Adding perimeter fence \(background.frame) to \(background.name ?? "background")")
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
        background.physicsBody?.collisionBitMask = PhysicsCategory.Edge
    }
}
