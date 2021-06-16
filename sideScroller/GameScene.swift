//
//  GameScene.swift
//  sideScroller
//
//  Created by thunderChawla on 12/06/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var m_player:player = player();
    var m_sprite:SKTileGroupRule!;
    var deltaTime:Float = 0.0;
    
    var tileMap:SKTileMapNode = SKTileMapNode();
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.addChild(m_player.CreateShape());
        
        
        self.tileMap = self.childNode(withName: "Grass") as! SKTileMapNode

        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height

        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isEdgeTile = tileDefinition?.userData?["isEdge"] as? Bool
                if (isEdgeTile ?? false) {
                    let x = CGFloat(col) * tileSize.width - halfWidth
                    let y = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false;
                    tileNode.physicsBody?.collisionBitMask = 0;

                    tileMap.addChild(tileNode)
                }
            }
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        deltaTime = Float(currentTime - lastUpdateTime);
    }
}
