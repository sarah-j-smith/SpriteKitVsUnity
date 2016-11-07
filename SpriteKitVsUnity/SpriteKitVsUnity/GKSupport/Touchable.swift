//
//  Touchable.swift
//  PestControl
//
//  Created by Sarah Smith on 11/6/16.
//  Copyright © 2016 Smithsoft. All rights reserved.
//

import Foundation
import SpriteKit

/** Only should be implemented / complied with in iOS touch devices (not TV) */
protocol Touchable
{
    /** The rect in the objects coordinates which can be touched to trigger it */
    var triggerRect: CGRect { get }
    
    /** Was the object triggered by a touch at this given point?  Return true from
     this function to take ownership of the touch.  */
    func wasTriggered(worldPoint point: CGPoint) -> Bool
    
    /** On touch down, if triggered */
    func activate()
    
    /** On touch up, if triggered */
    func deactivate()
    
}

