//
//  GameScene.swift
//  sideScroller
//
//  Created by thunderChawla on 12/06/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    enum CategoryBitMask{
        static let redNode: UInt32 = 0b001;
        static let blueNode: UInt32 = 0b0010;
        static let obstacle: UInt32 = 0b0011;
        static let boundary: UInt32 = 0b1000;
    }
    
    
    var m_player:player = player();
    var m_sprite:SKTileGroupRule!;
    var deltaTime:Float = 0.0;
    
    var tileMap:SKTileMapNode = SKTileMapNode();
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.addChild(m_player.CreateShape());
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CategoryBitMask.boundary;
        self.physicsWorld.contactDelegate = self;
        
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
                    tileNode.physicsBody?.collisionBitMask = CategoryBitMask.obstacle;
                    tileNode.physicsBody?.categoryBitMask = CategoryBitMask.boundary;

                    tileMap.addChild(tileNode)
                }
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if touch.location(in: self.view).x < 200
            {
                m_player.move(x: -200,y: 0);
            }
            else if touch.location(in: self.view).x < 400
            {
                m_player.move(x: 200,y: 0);
            }
            
            else{
                m_player.move(x: 0,y: 700);
        
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        deltaTime = Float(currentTime - lastUpdateTime);
    }
}
