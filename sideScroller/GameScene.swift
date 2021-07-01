//
//  GameScene.swift
//  sideScroller
//
//  Created by thunderChawla on 12/06/21.
//

import SpriteKit
import GameplayKit

class coin
{
    enum CategoryBitMask{
        static let redNode: UInt32 = 0b001;
        static let blueNode: UInt32 = 0b0010;
        static let obstacle: UInt32 = 0b0011;
        static let boundary: UInt32 = 0b1000;
    }
    var textures:[SKTexture] = []
    var shape: SKSpriteNode!
    func CreateShape(_position:CGPoint) -> SKSpriteNode
    {
        shape = SKSpriteNode(imageNamed: "coin1")
        shape.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        shape.scale(to: CGSize(width: 64, height: 64))
        shape.position = _position
        

        let textureAtlas = SKTextureAtlas(named: "coin")
       
        for i in 2...6
        {
            textures.append(SKTexture(imageNamed: "coin\(i)"))
            print("coin\(i).png")
        }
        return shape;
        
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    enum CategoryBitMask{
        static let redNode: UInt32 = 0b001;
        static let blueNode: UInt32 = 0b0010;
        static let obstacle: UInt32 = 0b0011;
        static let boundary: UInt32 = 0b1000;
    }
    var doorActive:Bool = false;
    
    var m_coins:[coin] = [];
    var hud:HUD = HUD();
    var m_player:player = player();
    var m_sprite:SKTileGroupRule!;
    var deltaTime:Float = 0.0;
    
    var tileMap:SKTileMapNode = SKTileMapNode();
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let left = SKSpriteNode()
    let jumpAudioNode = SKAudioNode(fileNamed: "Jump.wav");
    var m_emitter:SKEmitterNode!
    var m_coin:SKSpriteNode!
   
    
    override func didMove(to view: SKView)
    {
        
        self.listener = m_player;
        
       
        let tempCoin = coin()
        self.addChild(tempCoin.CreateShape(_position: CGPoint(x: 500, y: 500)))
        
        tempCoin.shape.run(SKAction.repeatForever(SKAction.animate(with:tempCoin.textures, timePerFrame: 0.2)))
        m_coins.append(tempCoin)

        self.addChild(hud.m_livesLabel);
        self.addChild(hud.m_scoreLabel);
        self.addChild(hud.m_left);
        self.addChild(hud.m_right);
        self.addChild(m_player.CreateShape());
        m_player.hud = hud;
        //self.addChild(m_player.audioNode);
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

        var tileSize = tileMap.tileSize
        var halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        var halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height

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
                    tileNode.name = "Ground"
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false;
                    tileNode.physicsBody?.collisionBitMask = CategoryBitMask.obstacle;
                    tileNode.physicsBody?.categoryBitMask = CategoryBitMask.boundary;

                    tileMap.addChild(tileNode)
                }
            }
        }
        
        self.tileMap = self.childNode(withName: "Interactables") as! SKTileMapNode

        tileSize = tileMap.tileSize
        halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height

        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isEdgeTile = tileDefinition?.userData?["Damage"] as? Bool
                if (isEdgeTile ?? false) {
                    let x = CGFloat(col) * tileSize.width - halfWidth
                    let y = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.name = "Damage"
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false;
                    tileNode.physicsBody?.collisionBitMask = CategoryBitMask.obstacle;
                    tileNode.physicsBody?.categoryBitMask = CategoryBitMask.boundary;

                    tileMap.addChild(tileNode)
            }
        }
        }
        
        //tileMap.removeFromParent();
        
        
        let audioNode = SKAudioNode(fileNamed: "Loop.wav");
        audioNode.autoplayLooped = true;
        self.addChild(audioNode)
        audioNode.run(SKAction.play())
        

        jumpAudioNode.autoplayLooped = true;
        self.addChild(jumpAudioNode)
        
    }
    
    func addDoorway()
    {
        if let emmiter = SKEmitterNode(fileNamed: "Magic")
        {
            m_emitter = emmiter
            m_emitter.position = CGPoint(x: 2080, y: 900);                                 
            self.addChild(m_emitter);
        }
    }
        
    
    @objc func swipe(sender: UISwipeGestureRecognizer)
    {
        if(sender.location(in: self.view).x > 600.0)
        {
            if(m_player.m_isGrounded)
            {
                //jumpAudioNode.run(SKAction.play());
                run(SKAction.playSoundFileNamed("Jump", waitForCompletion: true))
            }
            m_player.Jump();
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
            if let view = self.view
            {
                for node in nodesarray
                {
                    if node.name == "left"
                    {
                        m_player.move(x: -400, y: 0);
                    }
                    
                    if node.name == "right"
                    {
                        m_player.move(x: 400, y: 0);
                    }
                }
            }
        }
    }
//
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
            if let view = self.view
            {
                for node in nodesarray
                {
                    if node.name == "left"
                    {
                        m_player.move(x: -400, y: 0);
                    }
                    
                    if node.name == "right"
                    {
                        m_player.move(x: 400, y: 0);
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        m_player.move(x: 0.001, y: 0.0)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        deltaTime = Float(currentTime - lastUpdateTime);
        
        if(!doorActive && m_coins.count == 0)
    
        {
            doorActive = true;
            addDoorway();
        }
        var i:Int = 0
        for coin in m_coins
        {
            
            if(coin.shape.position.x - m_player.shape.position.x < 64 && (coin.shape.position.y - m_player.shape.position.y) < 64)
            {
                if let coinEffect = SKEmitterNode(fileNamed: "Coin")
                {
                    coinEffect.position = coin.shape.position
                    self.addChild(coinEffect)
                    
                    coinEffect.run(SKAction.sequence([SKAction.wait(forDuration: 2.5), (SKAction.removeFromParent())]));
                }
                
                coin.shape.removeFromParent();
                
                m_coins.remove(at: i)
                hud.increaseScore()
                break;
            }
            i += 1;
        }
        
        m_player.Update(dt: deltaTime);
        hud.Update(deltaTime: deltaTime, camera: m_player.camera);
    }
}
