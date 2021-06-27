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
    var m_livesLabel:SKLabelNode!
    var m_timerLabel:SKLabelNode!
    
    var m_lives:Int = 3
    var m_timer:Int = 60
    
    init()
    {
        m_livesLabel = SKLabelNode(fontNamed: "Arial")
        m_livesLabel.text = String(m_lives);
        m_timerLabel = SKLabelNode(fontNamed: "Arial")
        m_timerLabel.text = String(m_timer);
    }
    
    func Update(deltaTime:Float, camera:Camera)
    {
        m_livesLabel.position = camera.position
        m_livesLabel.position.x -= 800.0
        m_livesLabel.position.y += 500.0
        m_timerLabel.position = camera.position
        m_timerLabel.position.x += 800.0
        m_timerLabel.position.y += 500.0
//
        m_livesLabel.text = String(m_lives);
        m_timerLabel.text = String(m_timer);


    }
}
