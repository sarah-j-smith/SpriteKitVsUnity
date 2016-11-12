//
//  FollowPath.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 11/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit


class FollowPath: GKComponent, Loadable, BehaviourProvider
{
    @GKInspectable var followSpeed: Float = 100.0
    @GKInspectable var predictionTime: Float = 1.0
    @GKInspectable var radius: Float = 30.0
    @GKInspectable var pathName: String = "Path Name"
    
    private weak var _graph: GKGraph?
    
    private var targetPoint: GKGraphNode2D?

    var behaviourName: String {
        return "FollowPath \(pathName) \(entity?.sprite?.name! ?? "unnamed enemy")"
    }
    
    func wasLoaded(into scene: SKScene)
    {
        guard let gameplayScene = scene as? GameplayScene else { return }
        guard let graph = gameplayScene.graphs[pathName] else {
            print("Could not find graph for FollowPath named \(pathName)")
            return
        }
        _graph = graph
    }
    
    /** Create a path from where the agent is located to some other random location in the
        graph.  Under the hood creates a node for the location of the agent, joins it to
        the graph, generates the path and then removes that node again after. */
    private func updatePath(for agent: GKAgent2D) -> GKPath?
    {
        if let actualTargetPoint = targetPoint
        {
            guard let newTargetNode = _graph?.randomNode() as? GKGraphNode2D else { return nil }
            guard let path = _graph?.findPath(from: actualTargetPoint, to: newTargetNode) else { return nil }
            targetPoint = newTargetNode
            return GKPath(graphNodes: path, radius: radius)
        }
        
        guard let graph = _graph else {
            print("No graph intialised")
            return nil
        }
        guard let nodes = graph.nodesInDistanceOrder(from: agent.positionAsCGPoint()) else {
            print("No nodes in graph \(pathName)")
            return nil
        }
        if nodes.count < 3 {
            print("Need more than 2 nodes in graph \(pathName)")
            return nil
        }
        let nearNode = nodes.first!
        let targetNode = nodes.last!
        let startNode = GKGraphNode2D(point: agent.position)
        startNode.addConnections(to: [ nearNode ], bidirectional: true)
        let path = graph.findPath(from: startNode, to: targetNode)
        graph.remove([startNode])
        targetPoint = targetNode
        if !path.isEmpty
        {
            return GKPath(graphNodes: path, radius: radius)
        }
        print("Could not find a path from \(startNode.position) to \(targetNode.position) in \(pathName)")
        return nil
    }
    
    func goal(_ enemyAgent: GKAgent2D, withPlayerAgent playerAgent: GKAgent2D) -> GKGoal?
    {
        if let path = updatePath(for: enemyAgent)
        {
            print("Sending \(entity?.sprite?.name ?? "Unknown zombie") to \(targetPoint!.point())")
            for ii in 0 ..< path.numPoints
            {
                print("  > \(path.float2(at: ii))")
            }
            return GKGoal(toFollow: path, maxPredictionTime: TimeInterval(predictionTime), forward: true)
        }
        print("No path available \(pathName)")
        return nil
    }
    
    override func update(deltaTime seconds: TimeInterval)
    {
        if let pos = entity?.sprite?.position, let tgt = targetPoint?.point()
        {
            let dist = tgt.distanceTo(pos)
            if dist < 10.0
            {
                guard let zombieBase = entity?.component(ofType: ZombieEnemy.self) else { return }
                zombieBase.aiUpdateRequired = true
                print("At target \(entity?.sprite?.name ?? "Unknown zombie")")
            }
        }
    }
}

