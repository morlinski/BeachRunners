//
//  GameScene.swift
//  BeachRunners
//
//  Created by Monika on 2017-09-01.
//  Copyright © 2017 Monika. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var sandDoons : SKSpriteNode?
    private var freshRun = true
    private var canMove = false
    private var player: Player?
    private var friend1: NPC?
    private var enemy1: NPC?
    private var enemy2: NPC?
    
    private var minX : CGFloat = 0.0;
    private var maxX : CGFloat = 0.0;
    private var minY : CGFloat = 0.0;
    private var maxY : CGFloat = 0.0;
    
    private var downGravity : UIGravityBehavior?
    private var upGravity: UIGravityBehavior?
    private var leftGravity: UIGravityBehavior?
    private var rightGravity: UIGravityBehavior?
    
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        if freshRun {
            physicsWorld.contactDelegate = self
            physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
            
            maxX = (scene?.frame.width)! / 2
            maxY = (scene?.frame.height)! / 2
            
            initializeGame()
            makeSandDoons()
            self.addChild(sandDoons!)
            
            freshRun = false
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }*/
        canMove = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }*/
        if canMove {
            player?.moveTowards(point: pos, maxX: maxX, maxY: maxY)
        }
    }
    
    func keepInBounds(posX: CGFloat, posY: CGFloat) {
        //seperate logic in player and npc controllers.
    }
    
    func touchUp(atPoint pos : CGPoint) {
        /*if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }*/
        canMove = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        friend1?.keepInBounds(maxX: maxX, maxY: maxY)
        enemy1?.keepInBounds(maxX: maxX, maxY: maxY)
        enemy2?.keepInBounds(maxX: maxX, maxY: maxY)
        player?.keepInBounds(maxX: maxX, maxY: maxY)
    }
    
    //MARK: GameScene logic
    private func TileSprite(spriteNode: SKSpriteNode, texture: UIImage, coverageSize: CGSize) {
        print("TileSprite method started")
        let textureSize = CGRect(origin: CGPoint.zero, size: texture.size);
        
        print(texture.size)
        print(coverageSize)
        
        UIGraphicsBeginImageContext(coverageSize)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(texture.cgImage!, in: textureSize, byTiling: true)
        let tiledBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        spriteNode.texture = SKTexture(cgImage: (tiledBackground?.cgImage)!)
        spriteNode.size = coverageSize;
    }
    private func TileSpriteFullWidthAndHeight(spriteNode: SKSpriteNode, texture: UIImage, coverageSize: CGSize) {
        print("TileSprite method started")
        let textureSize = CGRect(origin: CGPoint.zero, size: texture.size);
        
        print(texture.size)
        print(coverageSize)
        
        UIGraphicsBeginImageContext(coverageSize)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(texture.cgImage!, in: textureSize, byTiling: true)
        let tiledBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        spriteNode.texture = SKTexture(cgImage: (tiledBackground?.cgImage)!)
        spriteNode.size = coverageSize;
    }
    
    public func makeSandDoons() {
        sandDoons = SKSpriteNode()
        let image = UIImage(named: "Beach 1")
        //let size = CGSize(width: self.frame.width, height: 152)
        let size = CGSize(width: self.frame.width, height: self.frame.height)
        
        TileSpriteFullWidthAndHeight(spriteNode: sandDoons!, texture: image!, coverageSize: size)
        sandDoons?.zPosition = 10
        print("Making Sand Doons?")
    }
    
    private func initializeGame(){
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0/*-0.075*/)
        player = childNode(withName: "Player") as? Player!;
        player?.initializePlayer();
        
        friend1 = childNode(withName: "Friend1") as? NPC!;
        enemy1 = childNode(withName: "Enemy1") as? NPC!;
        enemy2 = childNode(withName: "Enemy2") as? NPC!;
        
        friend1?.initializePlayer()
        enemy1?.initializePlayer()
        enemy2?.initializePlayer()
        
        //downGravity = childNode(withName: "DownGravity") as? UIGravityBehavior!
        //downGravity?.gravityDirection = CGVector(dx: 0.0, dy:  -1.0)
    }

}
