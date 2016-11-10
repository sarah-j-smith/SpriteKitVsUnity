//
//  TreasureMap.swift
//  SpriteKitVsUnity
//
//  Created by Sarah Smith on 9/11/16.
//  Copyright © 2016 Smithsoft Pty Ltd. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class TreasureMap: GKComponent, Loadable
{
    @GKInspectable var treasure: String = "treasure"
    
    typealias TileCoordinates = (column: Int, row: Int)
    
    func tileDefinition(in tileMap: SKTileMapNode, at coordinates: TileCoordinates) -> SKTileDefinition?
    {
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    func wasLoaded(into scene: SKScene) {
        guard let tileMap = entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKTileMapNode else {
            print("Attach this component to a Tile Map")
            return
        }
        
        let treasureNode = SKNode()
        treasureNode.name = treasure + "Map"
        treasureNode.position = tileMap.position
        scene.addChild(treasureNode)
        
        var treasureCount = 0
        for row in 0 ..< tileMap.numberOfRows {
            for col in 0 ..< tileMap.numberOfColumns {
                let tile = tileDefinition(in: tileMap, at: (col, row))
                if tile == nil { continue }
                if let actualTreasure = GKScene(fileNamed: treasure)?.contentNode()
                {
                    actualTreasure.node.removeFromParent()
                    treasureCount += 1
                    treasureNode.load(childNode: actualTreasure)
                    actualTreasure.node.position = tileMap.centerOfTile(atColumn: col, row: row)
                }
                else
                {
                    print("Could not load \(treasure) for map \(tileMap.name!)")
                    return
                }
            }
        }
        
        print("Set up \(treasureCount) instances in \(tileMap.name!) to \(treasure)")
        tileMap.removeFromParent()
    }
}
