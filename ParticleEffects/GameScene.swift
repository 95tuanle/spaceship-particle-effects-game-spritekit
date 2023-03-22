//
//  GameScene.swift
//  ParticleEffects
//
//  Created by Tuan Le on 2023-01-19.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundNode: SKSpriteNode?
    var playerNode: SKSpriteNode?
    var enemy1Node: SKSpriteNode?
    var enemy2Node: SKSpriteNode?
    var powerUpNode: SKSpriteNode?
    
    var moveRightAction: SKAction?
    var moveLeftAction: SKAction?
    var scaleAction: SKAction?
    var alphaOutAction: SKAction?
    var alphaInAction: SKAction?
    var colorAction: SKAction?
    var sequenceAction: SKAction?
    
    var scoreLabel: SKLabelNode?
    var restartLabel: SKLabelNode?
    
    var score: Int?
    
    var smokeParticle: SKEmitterNode?
    var bokehParticle: SKEmitterNode?
    var firefliesParticle: SKEmitterNode?
    
    
    override init(size: CGSize) {
        super.init(size: size)
        setupScene()
    }
    
    func setupScene() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.3)
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        name = "frame"
        score = 0

        
//        let magicParticle = SKEmitterNode(fileNamed: "Magic.sks")
//        magicParticle?.position = CGPoint(x: size.width/2, y: size.height/2)
//        magicParticle?.zPosition = -1
//        addChild(magicParticle!)
        
        smokeParticle = SKEmitterNode(fileNamed: "Smoke.sks")
        
        bokehParticle = SKEmitterNode(fileNamed: "Bokeh.sks")
        bokehParticle?.position = CGPoint(x: size.width/2, y: size.height/2)
        bokehParticle?.zPosition = -1
        addChild(bokehParticle!)
        
        firefliesParticle = SKEmitterNode(fileNamed: "Fireflies.sks")
        firefliesParticle?.position = CGPoint(x: size.width/2, y: size.height/2)
        firefliesParticle?.zPosition = -1
        addChild(firefliesParticle!)
        
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode?.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode?.zPosition = -1
        backgroundNode?.size.width = frame.size.width
        addChild(backgroundNode!)

        playerNode = SKSpriteNode(imageNamed: "Player")
        playerNode?.position = CGPoint(x: size.width/2, y: size.height*9/10)
        playerNode?.physicsBody = SKPhysicsBody(circleOfRadius: playerNode!.size.width)
        playerNode?.physicsBody?.isDynamic = true
        playerNode?.zPosition = +1
        playerNode?.name = "player"
        playerNode?.physicsBody?.contactTestBitMask = (playerNode?.physicsBody!.collisionBitMask)!
        addChild(playerNode!)
        
        enemy1Node = SKSpriteNode(imageNamed: "BlackHole0")
        enemy1Node?.position = CGPoint(x: 0, y: size.height/3)
        enemy1Node?.physicsBody = SKPhysicsBody(circleOfRadius: enemy1Node!.size.width)
        enemy1Node?.physicsBody?.isDynamic = false
        enemy1Node?.zPosition = +1
        enemy1Node?.name = "enemy"
        enemy1Node?.physicsBody?.contactTestBitMask = (enemy1Node?.physicsBody!.collisionBitMask)!
        addChild(enemy1Node!)
        
        enemy2Node = SKSpriteNode(imageNamed: "BlackHole0")
        enemy2Node?.position = CGPoint(x: size.width, y: size.height*2/3)
        enemy2Node?.physicsBody = SKPhysicsBody(circleOfRadius: enemy2Node!.size.width)
        enemy2Node?.physicsBody?.isDynamic = false
        enemy2Node?.zPosition = +1
        enemy2Node?.name = "enemy"
        enemy2Node?.physicsBody?.contactTestBitMask = (enemy2Node?.physicsBody!.collisionBitMask)!
        addChild(enemy2Node!)
        
        powerUpNode = SKSpriteNode(imageNamed: "PowerUp")
        powerUpNode?.position = CGPoint(x: CGFloat.random(in: size.width/18...size.width*17/18), y: CGFloat.random(in: size.height/18...size.height*17/18))
        powerUpNode?.physicsBody = SKPhysicsBody(circleOfRadius: powerUpNode!.size.width)
        powerUpNode?.physicsBody?.isDynamic = false
        powerUpNode?.zPosition = +1
        powerUpNode?.name = "powerUp"
        powerUpNode?.physicsBody?.contactTestBitMask = (powerUpNode?.physicsBody!.collisionBitMask)!
        addChild(powerUpNode!)

        
        scoreLabel = SKLabelNode(text: "Score: \(score ?? 0)")
        scoreLabel?.fontName = "Helvetica-Bold"
        scoreLabel?.position = CGPoint(x: size.width/2, y: size.height*9/10)
        addChild(scoreLabel!)
        
        moveRightAction = SKAction.move(by: CGVector(dx: size.width, dy: 0), duration: 1)
        moveLeftAction = SKAction.move(by: CGVector(dx: -size.width, dy: 0), duration: 1)
        
//        scaleAction = SKAction.scale(to: 2, duration: 1)
        
        alphaOutAction = SKAction.fadeAlpha(to: 0, duration: 3)
        
//        alphaInAction = SKAction.fadeAlpha(to: 1, duration: 1)
        
//        colorAction = SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 1)
        
//        playerNode.run(scaleAction!)
//        playerNode.run(alphaAction!)
//        playerNode.run(colorAction!)
//        playerNode.run(moveAction!)

//        playerNode?.run(SKAction.repeatForever(SKAction.sequence([moveAction!, scaleAction!, colorAction!, alphaOutAction!, alphaInAction!])))
        enemy1Node?.run(SKAction.repeatForever(SKAction.sequence([moveRightAction!, moveLeftAction!])))
        enemy2Node?.run(SKAction.repeatForever(SKAction.sequence([moveLeftAction!, moveRightAction!])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scoreLabel?.text != "GAME OVER" {
            playerNode?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 133))
            score! += 1
            scoreLabel?.text = "Score: \(score ?? 0)"
        } else {
            removeAllChildren()
            removeAllActions()
            setupScene()
        }
    }
    
    func gameOver() {
        playerNode?.removeFromParent()
        bokehParticle?.removeFromParent()
        firefliesParticle?.removeFromParent()
        powerUpNode?.removeFromParent()
        enemy1Node?.removeFromParent()
        enemy2Node?.removeFromParent()
        smokeParticle?.removeFromParent()
        scoreLabel?.position = CGPoint(x: size.width/2, y: size.height/2)
        scoreLabel?.text = "GAME OVER"
        restartLabel = SKLabelNode(text: "tap to restart")
        restartLabel?.fontName = "Helvetica"
        restartLabel?.position = CGPoint(x: size.width/2, y: size.height/10)
        addChild(restartLabel!)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeAName = contact.bodyA.node!.name else { return }
        guard let nodeBName = contact.bodyB.node!.name else { return }
        
        if nodeAName == "frame" || nodeBName == "frame" {
            if (playerNode?.position.y)! < size.height/18 {
                gameOver()
            }
        } else if nodeAName == "enemy" || nodeBName == "enemy" {
            if (score! > 0) {
                removeAction(forKey: "alphaOutAction")
                smokeParticle?.alpha = 1
                smokeParticle?.removeFromParent()
                score! -= 1
                scoreLabel?.text = "Score: \(score ?? 0)"
                smokeParticle?.position = contact.contactPoint
                smokeParticle?.run(alphaOutAction!, withKey: "alphaOutAction")
                addChild(smokeParticle!)
            } else {
                gameOver()
            }
        } else if nodeAName == "powerUp" || nodeBName == "powerUp" {
            powerUpNode?.removeFromParent()
            powerUpNode?.position = CGPoint(x: CGFloat.random(in: size.width/18...size.width*17/18), y: CGFloat.random(in: size.height/18...size.height*17/18))
            addChild(powerUpNode!)
            score! += 3
            scoreLabel?.text = "Score: \(score ?? 0)"
        }

    }
}
