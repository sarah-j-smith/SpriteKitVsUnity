//
//  SKSpriteNode+TV.swift
//  Pest Contrl
//
//  Created by Sarah Smith on 4/2/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

extension GKComponent: Touchable
{
    var triggerRect: CGRect {
        get {
            guard let spriteNode = entity?.sprite else { return CGRect.null }
            let sz = spriteNode.size
            let anc = spriteNode.anchorPoint
            return CGRect(x: -sz.width * anc.x, y: -sz.height * anc.y, width: sz.width, height: sz.height)
        }
    }
    
    func wasTriggered(worldPoint point: CGPoint) -> Bool
    {
        guard let spriteNode = entity?.sprite else { return false }
        guard let nodeScene = spriteNode.scene else { return false }
        let localPoint = spriteNode.convert(point, from: nodeScene)
        let hit = triggerRect.contains(localPoint)
        if hit
        {
            activate()
        }
        return hit
    }
    
    func activate() {
        //
    }
    
    func deactivate() {
        //
    }
}
