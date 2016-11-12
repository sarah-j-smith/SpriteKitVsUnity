//
//  GKGraph+Agent.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 12/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GKGraph
{
    /** Return a random node in the graph */
    func randomNode() -> GKGraphNode?
    {
        guard let actualNodes = nodes else { return nil }
        let rand = GKRandomSource.sharedRandom()
        let targetNode = actualNodes[ rand.nextInt(upperBound: actualNodes.count) ]
        return targetNode
    }
    
    /** Return a list of nodes in the graph ordered by closest to farthest from the given
        postion.  If the graph is had no nodes, or is made of nodes other than GKGraphNode2D
        then it returns nil. */
    func nodesInDistanceOrder(from position: CGPoint) -> [ GKGraphNode2D ]?
    {
        guard let actualNodes = nodes as? [ GKGraphNode2D ] else {
            print("Cannot find nodesInDistanceOrder from graph without any GKGraphNode2D's")
            return nil
        }
        let sorted = actualNodes.sorted { (a: GKGraphNode2D, b: GKGraphNode2D) -> Bool in
            let aDist = a.point() - position
            let bDist = b.point() - position
            return aDist.lengthSquared() < bDist.lengthSquared()
        }
        return sorted
    }

    func listGraph()
    {
        guard let actualNodes = nodes as? [ GKGraphNode2D ] else { return }
        for nd in actualNodes
        {
            print("  > \(nd.position.x), \(nd.position.y)")
            for ndc in nd.connectedNodes as! [ GKGraphNode2D ]
            {
                print("      * \(ndc.position)")
            }
        }
    }

}

extension GKGraphNode2D
{
    func point() -> CGPoint
    {
        return CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
    }
}

extension GKAgent2D
{
    func positionAsCGPoint() -> CGPoint
    {
        return CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
    }
}
