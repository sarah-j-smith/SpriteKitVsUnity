//
//  BehaviourProvider.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 11/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol BehaviourProvider
{
    func goal(_ enemyAgent: GKAgent2D, withPlayerAgent playerAgent: GKAgent2D) -> GKGoal?

    var behaviourName: String { get }
}
