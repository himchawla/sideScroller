//
//  HUD.swift
//  sideScroller
//
//  Created by thunderChawla on 28/06/21.
//

import Foundation
import SpriteKit
import UIKit


class HUD
{
    
    func hurt()
    {
        m_lives -= 1;
    }
    var m_livesLabel:SKLabelNode!
    var m_scoreLabel:SKLabelNode!

    var m_left:SKSpriteNode!
    var m_right:SKSpriteNode!
    
    var m_lives:Int = 3
    var m_score:Int = 0
    
    init()
    {
        m_left = SKSpriteNode(imageNamed: "left")
        m_left.position = CGPoint(x: 300, y:700);
        m_left.scale(to: CGSize(width: 256.0, height: 256.0))
        m_left.zPosition = 100;
        m_left.anchorPoint = CGPoint(x: 0.5,y: 0.5);
        m_left.name = "left";
        
        m_right = SKSpriteNode(imageNamed: "right")
        m_right.position = CGPoint(x: 300, y:700);
        m_right.scale(to: CGSize(width: 256.0, height: 256.0))
        m_right.zPosition = 100;
        m_right.anchorPoint = CGPoint(x: 0.5,y: 0.5);
        m_right.name = "right";
        
        m_livesLabel = SKLabelNode(fontNamed: "Arial")
        m_livesLabel.text = String(m_lives);
        m_scoreLabel = SKLabelNode(fontNamed: "Arial")
        m_scoreLabel.text = String(m_score);
    }
    
    func increaseScore()
    {
        m_score += 1;
    }
    
    func Update(deltaTime:Float, camera:Camera)
    {
        m_livesLabel.position = camera.position
        m_livesLabel.position.x -= (m_livesLabel.parent?.frame.width ?? 0) / 2.8;
        //print(m_livesLabel.position.x)
        m_livesLabel.position.y += (m_livesLabel.parent?.frame.height ?? 0) / 2.8;
        m_scoreLabel.position = camera.position
        m_scoreLabel.position.x += (m_scoreLabel.parent?.frame.width ?? 0) / 2.8
        m_scoreLabel.position.y += (m_scoreLabel.parent?.frame.height ?? 0) / 2.8
//
        m_left.position = camera.position
        m_left.position.x -= (m_left.parent?.frame.width ?? 0) / 2.8
        m_left.position.y -= (m_left.parent?.frame.height ?? 0) / 2.8
        
        m_right.position = camera.position
        m_right.position.x -= (m_left.parent?.frame.width ?? 0) / 4.4
        m_right.position.y -= (m_left.parent?.frame.height ?? 0) / 2.8
//
        m_livesLabel.text = String(m_lives);
        m_scoreLabel.text = String(m_score);


    }
}


