//
//  Points.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 10/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit

class Points: GKComponent, Loadable
{
    var points = 0
    var obs: NSObjectProtocol?
    
    deinit {
        if let actualObs = obs
        {
            NotificationCenter.default.removeObserver(actualObs)
        }
    }
    
    func wasLoaded(into scene: SKScene) {
        guard let actualLabel = entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKLabelNode else
        {
            print("Points was not a label")
            return
        }
        obs = NotificationCenter.default.addObserver(forName: Treasure.TREASURE_NOTIFICATION, object: nil, queue: OperationQueue.main, using: {(notifier: Notification) -> Void in
            if let additionalPoints = notifier.userInfo?["Points"] as? Int
            {
                self.points += additionalPoints
                actualLabel.text = String(format: "%04d", self.points)
            }
        })
    }
}
