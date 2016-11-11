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
    private weak var _enemyAgent: GKAgent2D?
    
    private var targetPoint: CGPoint?

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

    private func setupGraphPath(for agent: GKAgent2D) -> GKPath?
    {
        var graphPath: GKPath?
        _enemyAgent = agent
        guard let graph = _graph else {
            print("No graph intialised")
            return nil
        }
        guard let nodes = graph.nodes else {
            print("No nodes in graph \(pathName)")
            return nil
        }
        let rand = GKRandomSource.sharedRandom()
        let targetNode = nodes[ rand.nextInt(upperBound: nodes.count) ] as! GKGraphNode2D
        targetPoint = CGPoint(x: CGFloat(targetNode.position.x), y: CGFloat(targetNode.position.y))
        let startNode = GKGraphNode2D(point: agent.position)
        graph.connectToLowestCostNode(node: startNode, bidirectional: true)
        let path = graph.findPath(from: startNode, to: targetNode)
        for nd in graph.nodes!
        {
            let nd2 = nd as! GKGraphNode2D
            print("  > \(nd2.position.x), \(nd2.position.y)")
        }
        print(graph)
        if !path.isEmpty
        {
            graphPath = GKPath(graphNodes: path, radius: radius)
        }
        else
        {
            print("Could not find a path from \(startNode) to \(targetNode) in \(pathName)")
        }
        graph.remove([startNode])
        return graphPath
    }
    
    func goal(_ enemyAgent: GKAgent2D, withPlayerAgent playerAgent: GKAgent2D) -> GKGoal?
    {
        if let path = setupGraphPath(for: enemyAgent)
        {
            return GKGoal(toFollow: path, maxPredictionTime: TimeInterval(predictionTime), forward: true)
        }
        print("No path available \(pathName)")
        return nil
    }
    
    override func update(deltaTime seconds: TimeInterval)
    {
        if let pos = entity?.sprite?.position, let tgt = targetPoint
        {
            let dist = tgt.distanceTo(pos)
            if dist < 10.0
            {
                print("At target")
            }
        }
    }
}

