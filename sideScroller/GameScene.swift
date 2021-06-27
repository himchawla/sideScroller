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
    
    var hud:HUD = HUD();
    var m_player:player = player();
    var m_sprite:SKTileGroupRule!;
    var deltaTime:Float = 0.0;
    
    var tileMap:SKTileMapNode = SKTileMapNode();
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView)
    {
        self.addChild(hud.m_livesLabel);
        self.addChild(hud.m_timerLabel);
        self.addChild(m_player.CreateShape());
    
        self.camera = m_player.CreateCamera();
        self.addChild(m_player.camera);
        var swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe));
        swipeGestureRecognizer.direction = .up;
        //longPressGestureRecognizer.minimumPressDuration = 0.0;
        view.addGestureRecognizer(swipeGestureRecognizer);
        
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
    
    @objc func swipe(sender: UISwipeGestureRecognizer)
    {
        if(sender.location(in: self.view).x > 600.0)
        {
            m_player.Jump();
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            var tapLocation = touch.location(in: self.view);
            if(tapLocation.x < 200)
            {
                m_player.move(x: -400, y: 0);
            }
            
            else if(tapLocation.x < 400)
            {
                m_player.move(x: 400, y: 0);
            }
            
            else
            {
               // m_player.move(x: 0.0, y: 700.0);
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            var tapLocation = touch.location(in: self.view);
            if(tapLocation.x < 200)
            {
                m_player.move(x: -400, y: 0);
            }
            
            else if(tapLocation.x < 400)
            {
                m_player.move(x: 400, y: 0);
            }
            else
            {
                //m_player.move(x: 0.0, y: 700.0);
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        m_player.move(x: 0.001, y: 0.0)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        deltaTime = Float(currentTime - lastUpdateTime);
        
        m_player.Update(dt: deltaTime);
        hud.Update(deltaTime: deltaTime, camera: m_player.camera);
    }
}
