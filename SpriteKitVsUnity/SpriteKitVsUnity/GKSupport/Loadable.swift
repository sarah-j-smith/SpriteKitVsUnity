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

typealias NodeEntity = (node: SKNode, ent: GKEntity)

extension GKScene
{
    func contentNode() -> NodeEntity
    {
        if let contentNode = (rootNode as? SKScene)?.children.first
        {
            let contentEntity = entities.first { (e: GKEntity) -> Bool in
                return e.sprite == contentNode
            }
            if let actualContentEntity = contentEntity
            {
                return NodeEntity(node: contentNode, ent: actualContentEntity)
            }
            else
            {
                return NodeEntity(node: contentNode, ent: GKEntity())
            }
        }
        else
        {
            print("Error: No children in GKScene \((rootNode as? SKScene)?.name)")
        }
        return (node: SKNode(), ent: GKEntity())
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
            (scene as? GameplayScene)?.entities.append(childNode.ent)
            for c in childNode.ent.components
            {
                (c as? Loadable)?.wasLoaded(into: actualScene)
            }
        }
    }
}

protocol Loadable
{
    /** Called immediately after an entity is added to the scene */
    func wasLoaded(into scene: SKScene)
    
}
