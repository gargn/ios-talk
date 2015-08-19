//
//  Tetraminos.swift
//  TetrisGame
//
//  Created by Curtis Fenner on 7/14/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import SpriteKit

let SCALE: CGFloat = 0.5

/* Generates a tetramino block. */
private func tetramino_block(scene: SKScene, filename: String) -> SKSpriteNode {
    /* Creates block. */
    var block = SKSpriteNode(imageNamed: filename)
    block.position = CGPointMake(scene.frame.width/2, scene.frame.height)
    block.xScale = SCALE
    block.yScale = SCALE

    /* Adds physics to the tetramino block. */
    block.physicsBody = SKPhysicsBody(texture: block.texture, size: block.size)
    if let physics = block.physicsBody {
        physics.affectedByGravity = true
        physics.linearDamping = 7
        physics.categoryBitMask = BLOCKS_MASK
        physics.contactTestBitMask = BLOCKS_MASK | BARRIER_MASK | WALL_MASK
        physics.dynamic = true
        physics.usesPreciseCollisionDetection = true
    }
    
    scene.addChild(block)
    return block
}

/* ##
 * #
 * #   */
func tetraminoF(scene: SKScene) -> SKSpriteNode {
    return tetramino_block(scene, "tetraminos_F")
}

/* #
 * #
 * #
 * #   */
func tetraminoI(scene: SKScene) -> SKSpriteNode {
    return tetramino_block(scene, "tetraminos_I")
}

/* #
 * #
 * ##   */
func tetraminoL(scene: SKScene) -> SKSpriteNode {
    return tetramino_block(scene, "tetraminos_L")
}

/* ##
 * ##   */
func tetraminoO(scene: SKScene) -> SKSpriteNode {
    return tetramino_block(scene, "tetraminos_O")
}

/* #
 * ##
 * #   */
func tetraminoT(scene: SKScene) -> SKSpriteNode {
    return tetramino_block(scene, "tetraminos_T")
}

/* ##
 * ##  */
func tetraminoS(scene: SKScene) -> SKSpriteNode {
    return tetramino_block(scene, "tetraminos_S")
}

/* ##
 *  ##  */
func tetraminoZ(scene: SKScene) -> SKSpriteNode {
    return tetramino_block(scene, "tetraminos_Z")
}

/* Creates a tetramino based on the character provided. */
func tetramino(scene: SKScene, c: Character) -> SKSpriteNode? {
    switch c {
        case "F": return tetraminoF(scene)
        case "I": return tetraminoI(scene)
        case "L": return tetraminoL(scene)
        case "O": return tetraminoO(scene)
        case "T": return tetraminoT(scene)
        case "S": return tetraminoS(scene)
        case "Z": return tetraminoZ(scene)
    default:
        return nil
    }
}
