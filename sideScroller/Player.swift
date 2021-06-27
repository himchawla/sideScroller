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
    var m_isGrounded:Bool = false;
    var camera:Camera = Camera();
    
    enum CategoryBitMask{
        static let redNode: UInt32 = 0b001;
        static let blueNode: UInt32 = 0b0010;
        static let obstacle: UInt32 = 0b0011;
        static let boundary: UInt32 = 0b1000;
    }
    
    func CreateCamera()->SKCameraNode
    {
        camera.setScale(1);
        camera.position = shape.position;
        camera.zPosition = 10;
        
        return camera;
    }

    func CreateShape() -> SKSpriteNode
    {

        shape = SKSpriteNode(imageNamed: "tile001")
        shape.position = CGPoint(x: 300, y:700);
        shape.scale(to: CGSize(width: 64.0, height: 64.0))
        shape.anchorPoint = CGPoint(x: 0.5,y: 0.5);
        shape.physicsBody = SKPhysicsBody(circleOfRadius:32.0)
        shape.physicsBody?.collisionBitMask = CategoryBitMask.obstacle | CategoryBitMask.boundary;
        shape.physicsBody?.categoryBitMask = CategoryBitMask.blueNode;
        shape.physicsBody?.isDynamic = true;
        shape.physicsBody?.allowsRotation = false;
        shape.physicsBody?.friction = 0;
        shape.physicsBody?.mass = 0.2;
        body = shape.physicsBody;
        return shape;
    }
    
    func move(x: Float,y: Float)
    {
        shape.physicsBody?.velocity.dx = CGFloat(x);
    }
    
    func Jump()
    {
        if(m_isGrounded)
        {
        m_isGrounded = false;
        shape.physicsBody?.applyImpulse(CGVector(dx: CGFloat(0), dy: CGFloat(200)))
        }
        
    }

    func ReturnShape() -> SKSpriteNode
    {
        return shape;
    }
    
    func Update(dt: Float)
    {
        guard let vel:CGFloat = shape.physicsBody?.velocity.dy else {
            return
        }
        
        guard let count:Int = shape.physicsBody?.allContactedBodies().count else {
            return;
        }
        if(vel <= 0 && count > 0)
        {
            m_isGrounded = true;
        }
        camera.position = shape.position;
    }
}
