//
//  PerimeterFence.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import SpriteKit
import GameplayKit

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
    }
}
