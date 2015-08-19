//
//  GameScene.swift
//  TetrisGame
//
//  Created by Curtis Fenner on 7/14/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import SpriteKit
import CoreGraphics

/* Masks for block physics. */
let BLOCKS_MASK : UInt32  = 0x1 << 0
let BARRIER_MASK : UInt32 = 0x1 << 1
let WALL_MASK : UInt32 = 0x1 << 2

/* Testing flag for when store is not connected. */
var TEST_FLAG = true

/* Constant to slow down gravity's affect to make blocks fall slower. */
let GRAVITY_MAGNITUDE = -5

/* Scene containing information about the game. */
class GameScene: SKScene, SKPhysicsContactDelegate {
    //# MARK: - Instance variables
    
    /* Block state. */
    var currentBlock:SKSpriteNode?
    var blockSpins = 1
    var lastXPos: Double = 0

    /* Game state. */
    var timer:BlockTimer!
    var gameOver: Bool = false
    var score = 0
    var scoreLabel: UILabel = UILabel()
    var playerName: String = "Anonymous"

    /* Game views state. */
    var buyMorePopUp: UIView!
    var gameOverPopUp: UIView!
    var overlay: UIView!
    
    //# MARK: - Overridden functions

    /* First actions when view is redisplayed. */
    override func didMoveToView(view: SKView) {
        makeScoreLabel(view)
        
        /* Adds tap gesture to rotate falling blocks. */
        var tap = UITapGestureRecognizer(target: self, action: Selector("handleTaps:"))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        /* Creates barrier and bottom wall. */
        let barrierHeight: CGFloat = 25
        makeBarrier(250, barrierHeight: barrierHeight, barrierYPos: barrierHeight/2, categoryBitMask: BARRIER_MASK)
        makeBarrier(1000, barrierHeight: barrierHeight, barrierYPos: -barrierHeight/2, categoryBitMask: WALL_MASK)
        
        /* Sets background to white. */
        self.backgroundColor = SKColor.whiteColor()

        /* Creates a timer that generates a new block. */
        timer = BlockTimer(game: self)
        timer!.newBlock()
        
        /* Sets self as contract delegate indicating the current class has the
         * functions which handle physics occuring on an object.
         * Indicates magnitude of gravity on the scene. */
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: GRAVITY_MAGNITUDE)
    }
    
    //# MARK: - UI functions

    /* Draws a barrier. */
    func makeBarrier(barrierWidth: CGFloat, barrierHeight: CGFloat, barrierYPos: CGFloat, categoryBitMask: UInt32) {
        var newBarrier = SKShapeNode(rectOfSize: CGSize(width: barrierWidth, height: barrierHeight))
        /* Add color and position barrier. */

        /* Adds physics to barrier. */

        /* Add barrier to view. */
    }

    /* Makes the score label. */
    func makeScoreLabel(view: SKView) {
        score = 0
        scoreLabel = UILabel()
        updateScoreLabel()
        scoreLabel.frame.origin = CGPoint(x:0, y:44)
        scoreLabel.frame.size = CGSize(width: view.frame.width - 20, height: 50)
        scoreLabel.textAlignment = NSTextAlignment.Right
        view.addSubview(scoreLabel)
    }
    
    /* Sets score label's text. */
    func updateScoreLabel() {
        scoreLabel.text = "Score: " + String(score)
    }
    
    /* Shows the buy more popup. */
    func showBuyMore(){
        pauseGame()
        buyMorePopUp.hidden = false
        overlay.hidden = false
    }
    
    /* Hides the buy more popup if it is visible. */
    func hideBuyMore() {
        if !buyMorePopUp.hidden {
            unpauseGame()
            buyMorePopUp.hidden = true
            overlay.hidden = true
        }
    }
    
    //# MARK: - Game state functions
    
    /* Creates a new block (based on those available from the store), updating the currently
     * controlled block. */
    func dropBlock() {
        var next = store.nextBlock()
        blockSpins = 1
        
        /* If test flag is True then drop blocks without asking to purchase moree. */
        if TEST_FLAG {
            currentBlock = tetraminoI(self)
        } else {
            /* Drop the block if there is an available block
             * otherwise tell user to purchase more blocks. */
            if next != nil {
                score++
                currentBlock = tetramino(self, next!)
                hideBuyMore()
            } else {
                println("No more blocks. Purchase more.")
                showBuyMore()
            }
        }
        updateScoreLabel()
    }
    
    /* Returns score. */
    func getScore() -> Int {
        return score
    }
    
    /* Pause game. */
    func pauseGame() {
        physicsWorld.speed = 0
        timer.endTimer()
    }
    
    /* Unpauses game. */
    func unpauseGame() {
        physicsWorld.speed = 1
        timer.resetTimer(MAX_DROP_TIME)
    }
    
    /* Logic for the end of the game. */
    func endGame() {
        overlay.hidden = false
        gameOverPopUp.hidden = false
        timer!.endTimer()
        self.gameOver = true
        self.currentBlock = nil
        NSLog("Game Over")
    }
    
    /* Saves name. */
    func saveName(playerName: String){
        self.playerName = playerName
    }

    //# MARK: - Physics functions

    /* Determines contact occurred between a block and the bottom and if the game is over. */
    func didBeginContact(contact: SKPhysicsContact) {
        let (firstBody, secondBody) = getContactBodies(contact)

        /* Ends game if the block contacts the base block. */

        /* Resets timer to indicate block was touched.
         * Prevents current block from being moved/manipulated more. */
    }

    /* Returns the contact bodies with the lower bitmask as the first body. */
    func getContactBodies(contact: SKPhysicsContact) -> (SKPhysicsBody, SKPhysicsBody) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        /* Assigns the lower category into the first body. */
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        return (firstBody, secondBody)
    }
    
    //# MARK: - Gesture response functions
    
    /* Helps tap gesture rotate the block. */
    func handleTaps(sender: UITapGestureRecognizer) {
        /* Ensures pressing buttons on the pop-ups do not register as requests to rotate. */
        if physicsWorld.speed == 1 {
            /* Unwrap the current block and rotate. */
            if let block = currentBlock {
            }
        }
    }
    
    /* Dragging logic when touches begin. */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if  let touch = touches.first as? UITouch {
            lastXPos = Double(touch.locationInView(self.view).x)
        }
    }
    
    /* Dragging logic when touches move. */
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            if let touch = touch as? UITouch {
                /* Determines new location. */
                let location = touch.locationInView(self.view)
                let x = Double(location.x)
                
                /* Determines physics force relative to change in location. */
                if let block = currentBlock {
                    let dx = x - lastXPos
                    block.physicsBody!.applyForce(CGVector(dx: dx*20, dy: 0))
                }
                lastXPos = x
            }
        }
    }
}
