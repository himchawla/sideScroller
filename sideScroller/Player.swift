//
//  Player.swift
//  sideScroller
//
//  Created by thunderChawla on 12/06/21.
//

import Foundation
import SpriteKit;

class player:SKNode {
    
    var shape:SKSpriteNode!;
    var body:SKPhysicsBody!;
    
    
    func CreateShape() -> SKSpriteNode
    {
        shape = SKSpriteNode(imageNamed: "tile001")
        shape.position = CGPoint(x: 100, y:700);
       shape.scale(to: CGSize(width: 64.0, height: 64.0))
       shape.anchorPoint = CGPoint(x: 0.5,y: 0.5);
        shape.physicsBody = SKPhysicsBody(circleOfRadius:32.0)
        shape.physicsBody?.collisionBitMask = 0;
        shape.physicsBody?.isDynamic = true;
        
        shape.physicsBody?.mass = 0.2;
        body = shape.physicsBody;
        return shape;
    }

    func ReturnShape() -> SKSpriteNode
    {
        return shape;
    }
    
    func Update()
    {
        
    }
}
