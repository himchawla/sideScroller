//
//  GameScene.swift
//  sideScroller
//
//  Created by thunderChawla on 12/06/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var m_player:player?;
    var deltaTime:Float = 0.0;
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        deltaTime = Float(currentTime - lastUpdateTime);
    }
}
