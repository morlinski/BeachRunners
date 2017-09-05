//
//  NPC.swift
//  BeachRunners
//
//  Created by Monika on 2017-09-03.
//  Copyright © 2017 Monika. All rights reserved.
//

import SpriteKit

class NPC: SKSpriteNode {
    
    func initializePlayer() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.height/2);
        physicsBody?.affectedByGravity = true;
        physicsBody?.isDynamic = true;
        //physicsBody?.categoryBitMask = ColliderType.PLAYER
        //physicsBody?.contactTestBitMask = ColliderType.FRUIT_AND_BOMB;
    }
    func keepInBounds(maxX: CGFloat, maxY: CGFloat){
        var reducePull = false
        if position.x < -maxX { position.x = -maxX; reducePull = true; }
        if position.x > maxX { position.x = maxX; reducePull = true; }
        if position.y < -maxY { position.y = -maxY; reducePull = true; }
        if position.y > maxY { position.y = maxY; reducePull = true; }
        if reducePull {
            position.x = 0.0
            position.y = 0.0
            print(physicsBody!.mass)
            physicsBody!.mass = 0.45
            removeAllActions()
        }
    }
    
    }

