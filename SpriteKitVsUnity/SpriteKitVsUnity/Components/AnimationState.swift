//
//  AnimationState.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 9/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import Foundation
import GameplayKit

typealias StateAnimationHandler = () -> Void

class AnimationState: GKState
{
    static let ANIMATION_KEY = "StateAnimation"
    
    let name: String
    let targetNode: SKNode
    
    var animation: SKAction?
    
    var stateHandlers: [ StateAnimationHandler ]
    
    init(stateName: String, node: SKNode)
    {
        name = stateName
        targetNode = node
        stateHandlers = []
    }
    
    override func didEnter(from previousState: GKState?)
    {
        print("entering \(name) state")
        
        for handler in stateHandlers
        {
            handler()
        }
        if animation == nil
        {
            animation = SKAction(named: name)
        }
        if let actualAnim = animation
        {
            targetNode.removeAction(forKey: AnimationState.ANIMATION_KEY)
            targetNode.run(actualAnim, withKey: AnimationState.ANIMATION_KEY)
        }
    }
}

