//
//  GameScene.swift
//  sideScroller
//
//  Created by thunderChawla on 12/06/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0

    
    override func sceneDidLoad() {
        
    }
    
    override func didMove(to view: SKView) {
       
        let player = SKSpriteNode(fileNamed: "tile000");
        self.addChild(player!);
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
    
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        let dt = currentTime - self.lastUpdateTime
        
        
        
        self.lastUpdateTime = currentTime
    }
}
