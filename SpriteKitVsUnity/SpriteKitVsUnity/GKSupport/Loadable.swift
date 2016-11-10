//
//  Loadable.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

typealias NodeEntity = (node: SKNode, entities: [GKEntity])

extension GKScene {
    func contentNode() -> NodeEntity?
    {
        if let content = (rootNode as? SKScene)?.children.first
        {
            return (node: content, entities)
        }
        return nil
    }
}

extension SKNode
{
    func load(childNode: NodeEntity)
    {
        addChild(childNode.node)
        if let actualScene = scene
        {
            (childNode as? Loadable)?.wasLoaded(into: actualScene)
            (scene as? GameplayScene)?.entities.append(contentsOf: childNode.entities)
            for e in childNode.entities
            {
                for c in e.components
                {
                    (c as? Loadable)?.wasLoaded(into: actualScene)
                }
            }
        }
    }
}

protocol Loadable
{
    /** Called immediately after an entity is added to the scene */
    func wasLoaded(into scene: SKScene)
    
}
