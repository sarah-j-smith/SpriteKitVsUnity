//
//  ZombieEnemy.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 11/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//


import SpriteKit
import GameplayKit


class ZombieEnemy: GKComponent, Loadable, GKAgentDelegate
{
    @GKInspectable var speed: Float = 100.0
    @GKInspectable var mass: Float = 0.01
    @GKInspectable var acceleration: Float = 1000.0
    @GKInspectable var dps: Float = 10.0
    
    var aiUpdateRequired = true
    private weak var _playerAgent: GKAgent2D?
    private weak var _enemyAgent: GKAgent2D?
    
    private var historyMax = 10
    private var positionHistory: [CGPoint] = []
    
    var velocity: CGVector {
        get {
            if positionHistory.isEmpty
            {
                return CGVector.zero
            }
            guard let spr = entity?.sprite else { return CGVector.zero }
            let startPos = positionHistory.first!
            let delta = spr.position - startPos
            return CGVector(point: delta)
        }
    }
    
    func wasLoaded(into scene: SKScene)
    {
        guard let spr = entity?.sprite else { return }
        spr.nodeEntity = entity
        spr.userData?["ZOMBIE"] = 1
        
        spr.physicsBody = SKPhysicsBody(circleOfRadius: spr.size.width / 4.0)
        spr.physicsBody!.categoryBitMask = PhysicsCategory.Zombie
        spr.physicsBody!.collisionBitMask = PhysicsCategory.Barrier | PhysicsCategory.Player
        spr.physicsBody!.contactTestBitMask = PhysicsCategory.None
        spr.physicsBody!.affectedByGravity = false
        spr.physicsBody!.allowsRotation = false
        
        let agent = GKAgent2D()
        entity?.addComponent(agent)
        agent.delegate = self
        agent.position = float2(x: Float(spr.position.x), y: Float(spr.position.y))
        
        agent.mass = mass
        agent.maxSpeed = speed
        agent.maxAcceleration = acceleration
        _enemyAgent = agent
    }
    
    /** Called by the player object once its player agent is set up */
    func initialiseComponents(withPlayerAgent playerAgent: GKAgent2D)
    {
        guard let components = entity?.components else { return }
        guard let enemyAgent = _enemyAgent else { return }
        _playerAgent = playerAgent
        var goals = [ GKGoal ]()
        print("Initialising components for zombie enemy: \(entity?.sprite?.name!)")
        for comp in components
        {
            if let behaviour = comp as? BehaviourProvider
            {
                print("    > \(behaviour.behaviourName)")
                if let goal = behaviour.goal(enemyAgent, withPlayerAgent: playerAgent)
                {
                    goals.append(goal)
                }
            }
        }
        if goals.count > 0
        {
            print("Initialising enemy with goals: \(goals)")
            enemyAgent.behavior = GKBehavior(goals: goals)
        }
        aiUpdateRequired = false
    }
    
    func updateComponents()
    {
        guard let components = entity?.components else { return }
        guard let enemyAgent = _enemyAgent else { return }
        guard let playerAgent = _playerAgent else { return }
        var goals = [ GKGoal ]()
        print("Updating components for zombie enemy: \(entity?.sprite?.name!)")
        for comp in components
        {
            if let behaviour = comp as? BehaviourProvider
            {
                print("    > \(behaviour.behaviourName)")
                if let goal = behaviour.goal(enemyAgent, withPlayerAgent: playerAgent)
                {
                    goals.append(goal)
                }
            }
        }
        if goals.count > 0
        {
            print("Initialising enemy with goals: \(goals)")
            enemyAgent.behavior = GKBehavior(goals: goals)
        }
        aiUpdateRequired = false
    }
    
    func agentWillUpdate(_ agent: GKAgent)
    {
        if let agent = entity?.component(ofType: GKAgent2D.self), let spr = entity?.sprite
        {
            agent.position = float2(Float(spr.position.x), Float(spr.position.y))
        }
    }
    
    func agentDidUpdate(_ agent: GKAgent)
    {
        if let agent = entity?.component(ofType: GKAgent2D.self), let spr = entity?.sprite
        {
            positionHistory.append(spr.position)
            if positionHistory.count > historyMax
            {
                positionHistory.remove(at: 0)
            }
            spr.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
            
        }
    }
    
    override func update(deltaTime seconds: TimeInterval)
    {
        if aiUpdateRequired
        {
            updateComponents()
        }
    }
}


