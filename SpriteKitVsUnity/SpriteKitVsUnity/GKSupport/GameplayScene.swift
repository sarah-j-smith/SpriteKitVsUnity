//
//  GameplayScene.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameplayScene: SKScene
{
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime: TimeInterval = 0
    private var deltaTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        setupEntities()
        physicsWorld.contactDelegate = self
    }
    
    func setupEntities()
    {
        for e in entities
        {
            e.wasLoaded(into: self)
        }
    }
    
    // MARK: - Interaction Handlers
    
    private func touchEntities(worldPoint: CGPoint)
    {
        let touchable = entities.flatMap { $0.components.filter { $0 is Touchable } }
        let prioritised = touchable.sorted { (a: GKComponent, b: GKComponent) -> Bool in
            (a as! Touchable).priority < (b as! Touchable).priority
        }
        for e in prioritised
        {
            if (e as! Touchable).wasTriggered(worldPoint: worldPoint)
            {
                break
            }
        }
    }
    
    // MARK: - Update Handlers
    
    private func updateEntities(deltaTime: TimeInterval)
    {
        for e in entities
        {
            e.update(deltaTime: deltaTime)
        }
    }

    private func calculateDelta(_ currentTime: TimeInterval)
    {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTime
        updateEntities(deltaTime: deltaTime)
        
        lastUpdateTime = currentTime
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return }
        touchEntities(worldPoint: touch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    

    
    override func update(_ currentTime: TimeInterval)
    {
        calculateDelta(currentTime)
    }
    
}
