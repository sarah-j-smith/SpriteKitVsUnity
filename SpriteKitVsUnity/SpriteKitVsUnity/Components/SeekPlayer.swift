//
//  SeekPlayer.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 10/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit


class SeekPlayer: GKComponent, BehaviourProvider
{
    @GKInspectable var waitBeforeChasing: Float = 10.0
    
    var behaviourName: String {
        return "SeekPlayer \(entity?.sprite?.name! ?? "unnamed enemy")"
    }
    
    private var _timerComplete = true
    
    private var waitTimer: TimeInterval = 0.0
    
    func wasLoaded(into scene: SKScene)
    {
        waitTimer = TimeInterval(waitBeforeChasing)
        _timerComplete = false
    }

    func goal(_ enemyAgent: GKAgent2D, withPlayerAgent playerAgent: GKAgent2D) -> GKGoal?
    {
        return _timerComplete ? GKGoal(toSeekAgent: playerAgent) : nil
    }
    
    override func update(deltaTime seconds: TimeInterval)
    {
        if !_timerComplete
        {
            waitTimer -= seconds
            if waitTimer < 0.0
            {
                if let enemyAI = entity?.component(ofType: ZombieEnemy.self)
                {
                    enemyAI.aiUpdateRequired = true
                }
                _timerComplete = true
            }
        }
    }
}
