//
//  Button.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 10/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Button: GKComponent, Touchable
{
    @GKInspectable var message = "Button Message"
    
    var priority: Int { return 0 }

    var triggerRect: CGRect {
        get {
            guard let b = entity?.sprite else { return CGRect.null }
            return CGRect(x: -b.size.width * b.anchorPoint.x, y: -b.size.height * b.anchorPoint.y, width: b.size.width, height: b.size.height)
        }
    }
    
    func wasTriggered(worldPoint point: CGPoint) -> Bool {
        guard let buttonSprite = entity?.sprite else { return false }
        guard let scene = buttonSprite.scene else { return false }
        let pt = buttonSprite.convert(point, from: scene)
        if triggerRect.contains(pt)
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: message), object: nil)
            return true
        }
        return false
    }
}
