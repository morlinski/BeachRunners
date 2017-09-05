//
//  Player.swift
//  BeachRunners
//
//  Created by Monika on 2017-09-02.
//  Copyright © 2017 Monika. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    func initializePlayer() {
        name = "Player"
        physicsBody = SKPhysicsBody(circleOfRadius: size.height/2);
        physicsBody?.affectedByGravity = true;
        physicsBody?.isDynamic = true;
        //physicsBody?.categoryBitMask = ColliderType.PLAYER
        //physicsBody?.contactTestBitMask = ColliderType.FRUIT_AND_BOMB;
    }
    
    func moveTowards(point: CGPoint, maxX: CGFloat, maxY: CGFloat){
        /*if (point.x <= maxX && point.x > position.x) {
            position.x += 15
        }
        else if (point.x >= -maxX && point.x < position.x) {
            position.x -= 15
        }
        if (point.y >= -maxY && point.y < position.y) {
            position.y -= 15
        }
        else if (point.y <= maxY && point.y > position.y) {
            position.y += 15
        }*/
        zRotation = 0.0
        if (point.x <= maxX && point.x > (position.x)) {
            zRotation += 4.5
        }
        else if (point.x >= -maxX && point.x < (position.x)) {
            zRotation += 1.5
        }
        if ((point.y-30) >= -maxY && (point.y-30) < (position.y)) {
            zRotation += 0.5
        }
        else if ((point.y-30) <= maxY && (point.y-30) > (position.y)) {
            zRotation += 0.5
        }
 
        if(point.x >= (position.x-130) && point.x <= (position.x+130) && point.y >= (position.y-130) && point.y <= (position.y+130) ){
            position.x = point.x
            position.y = point.y + 30
            
            //zRotation = 3.0 //down
            //zRotation = 1.5 //left
            //zRotation = 4.5 //right
            //zRotation = 0.0 //up
        }
        
    }
    var inset = CGFloat(100.0);
        func keepInBounds(maxX: CGFloat, maxY: CGFloat){
            
            if position.x < -maxX{ position.x = -maxX + inset; print("out of bounds  x <"); }
            if position.x > maxX { position.x = maxX - inset; print("out of bounds  x >"); }
            if position.y < -maxY { position.y = -maxY + inset; print("out of bounds  y <"); }
            if position.y > maxY { position.y = maxY - inset; print("out of bounds  y >"); }

            physicsBody!.mass = 3.0 //make your body have the highest priority in collisions.
        }
}
