//
//  Wander.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 11/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

//
//  SeekPlayer.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 10/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit


class Wander: GKComponent, BehaviourProvider
{
    @GKInspectable var wanderSpeed = 100.0
    
    func goal(_ enemyAgent: GKAgent2D, withPlayerAgent playerAgent: GKAgent2D) -> GKGoal?
    {
        return GKGoal(toWander: Float(wanderSpeed))
    }
    
    var behaviourName: String {
        return "Wander \(entity?.sprite?.name! ?? "unnamed enemy")"
    }
    
    
}
