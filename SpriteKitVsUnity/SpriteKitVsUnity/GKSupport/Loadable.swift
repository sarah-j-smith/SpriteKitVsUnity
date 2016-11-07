//
//  Loadable.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import Foundation
import SpriteKit

protocol Loadable
{
    /** Called immediately after an entity is added to the scene */
    func wasLoaded(into scene: SKScene)
    
}
