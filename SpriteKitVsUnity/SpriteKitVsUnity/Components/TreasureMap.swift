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
        
        for row in 0 ..< tileMap.numberOfRows {
            for col in 0 ..< tileMap.numberOfColumns {
                let tile = tileDefinition(in: tileMap, at: (col, row))
                if tile != nil
                {
                    if let actualTreasure = SKNode(fileNamed: treasure)
                    {
                        treasureNode.addChild(actualTreasure)
                        actualTreasure.position = tileMap.centerOfTile(atColumn: col, row: row)
                    }
                }
            }
        }
        
        print("Set instances in \(tileMap) to \(treasure)")
        tileMap.removeFromParent()
    }
}
