//
//  CameraConstrain.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class CameraConstrain: GKComponent, Loadable
{
    @GKInspectable var target: String = "target"
    
    func wasLoaded(into scene: SKScene) {
        guard let actualCamera = entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKCameraNode else {
            print("Attach this component to a camera")
            return
        }
        guard let actualView = actualCamera.scene?.view else { return }
        guard let actualTarget = scene.childNode(withName: ".//\(target)") else {
            print("Could not find a target for the NodeFollow named \(target)")
            return
        }
        
        let xInset = min(actualView.bounds.width/2 * actualCamera.xScale, actualTarget.frame.width/2)
        let yInset = min(actualView.bounds.height/2 * actualCamera.yScale, actualTarget.frame.height/2)
        let constrainRect = actualTarget.frame.insetBy(dx: xInset, dy: yInset)
        let xRange = SKRange(lowerLimit: constrainRect.minX, upperLimit: constrainRect.maxX)
        let yRange = SKRange(lowerLimit: constrainRect.minY, upperLimit: constrainRect.maxY)
        let viewConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        var constraints = actualCamera.constraints ?? []
        constraints.append(viewConstraint)
        actualCamera.constraints = constraints
        
        print("Added camera view constrain to \(actualCamera.name!) within \(actualTarget.name!)")
    }
}
