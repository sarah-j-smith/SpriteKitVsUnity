//
//  GKEntity+SpriteKit.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import Foundation
import GameplayKit

extension GKEntity
{
    var sprite: SKSpriteNode? {
        return component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    }
    
    func wasLoaded(into scene: SKScene)
    {
        for c in components
        {
            (c as? Loadable)?.wasLoaded(into: scene)
        }
    }
}

struct WeakEntityReference
{
    weak var theEntity: GKEntity?
    
    init(entity: GKEntity) {
        theEntity = entity
    }
}

extension SKNode
{
    var nodeEntity: GKEntity? {
        get {
            return (userData?["ENTREF"] as? WeakEntityReference)?.theEntity
        }
        set {
            if let actualValue = newValue
            {
                if userData == nil
                {
                    userData = NSMutableDictionary()
                }
                userData!["ENTREF"] = WeakEntityReference(entity: actualValue)
            }
            else
            {
                userData?["ENTREF"] = nil
            }
        }
    }
}
