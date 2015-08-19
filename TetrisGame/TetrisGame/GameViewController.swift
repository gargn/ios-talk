//
//  GameViewController.swift
//  TetrisGame
//
//  Created by Curtis Fenner on 7/14/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import UIKit
import SpriteKit

/* Function helps utilize the GameScene.sks. */
extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

/* The GameViewController for the main game view. */
class GameViewController: UIViewController {
    /* The current game scene */
    var scene: GameScene?

    /* The views available to be visible on the GameViewController. */
    @IBOutlet var overlay: UIView!
    @IBOutlet var pausePopUp: UIView!
    @IBOutlet var gameOverPopUp: UIView!
    @IBOutlet var buyMorePopUp: UIView!
    
    /* Connection to the player name text field component. */
    @IBOutlet var playerName: UITextField!

    /* Indicates what happens when the view loads. */
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Hides all popups to begin with. */
        gameOverPopUp.hidden = true
        pausePopUp.hidden = true
        buyMorePopUp.hidden = true
        overlay.hidden = true

        /* Loads the game and displays and connects the value of the popups
         * to that of the views in the GameScene so they will be updated
         * as the game changes. */
        scene = GameScene.unarchiveFromFile("GameScene") as? GameScene
        scene?.gameOverPopUp = gameOverPopUp
        scene?.buyMorePopUp = buyMorePopUp
        scene?.overlay = overlay

        /* Unwraps scene if it exists, to configure and optimize. */
        if let scene = scene {
            /* Configure the view. */
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance. */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window. */
            scene.scaleMode = .AspectFill
            
            /* Present the scene. */
            skView.presentScene(scene)
        }
    }
    
    /* Save game and end game if navigating away from the screen.
     * Adds player score to the scores. */
    override func viewDidDisappear(animated: Bool) {
        if let scene = scene {
            dataLoader.addPlayer(Player(name: scene.playerName, score: scene.getScore()))
            scene.endGame()
        }
        scene = nil
    }

    /* Prevents screen from autorotating. */
    override func shouldAutorotate() -> Bool {
        return false
    }

    /* Permits only portrait views. */
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    /* Status bar is hidden on this screen. */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /* Action for pausing game. */
    @IBAction func showPause(){
        scene?.pauseGame()
        overlay.hidden = false
        pausePopUp.hidden = false
    }

    /* Action for unpausing game. */
    @IBAction func hidePause(){
        pausePopUp.hidden = true
        overlay.hidden = true
        scene!.unpauseGame()
    }

    /* Action for entering name in the game over screen. */
    @IBAction func enterName(){
        scene!.saveName(playerName.text)
        overlay.hidden = true
        gameOverPopUp.hidden = true
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
