//
//  NodeFollow.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import SpriteKit
import GameplayKit

class NodeFollow: GKComponent, Loadable
{
    @GKInspectable var target: String = "target"
    
    func wasLoaded(into scene: SKScene)
    {
        guard let actualNode = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return }
        guard let actualTarget = scene.childNode(withName: ".//\(target)") else {
            print("Could not find a target for the NodeFollow named \(target)")
            return
        }
        
        print("Added node follow to \(actualTarget.name!) from \(actualNode.name!)")
        
        let zeroDistance = SKRange(constantValue: 0)
        let nodeFollowConstraint = SKConstraint.distance(zeroDistance, to: actualTarget)
        
        var constraints = actualNode.constraints ?? []
        constraints.append(nodeFollowConstraint)
        actualNode.constraints = constraints
    }
    
}
