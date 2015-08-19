//
//  BlockTimer.swift
//  TetrisGame
//
//  Created by Nupur Garg on 7/15/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import Foundation

let MAX_DROP_TIME: NSTimeInterval = 10
let MIN_DROP_TIME: NSTimeInterval = 0.5

/* Block timer which times how the blocks drop. */
class BlockTimer: NSObject {
    var timer: NSTimer?
    var game: GameScene

    /* Initializes block timer with the game it is associated with. */
    init(game: GameScene) {
        self.game = game
    }

    /* Resets the timer. */
    func resetTimer(interval: NSTimeInterval) {
        endTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self,
            selector: Selector("newBlock"), userInfo: nil, repeats: false)
    }

    /* Resets the timer if block was touched. */
    func blockTouched() {
        resetTimer(MIN_DROP_TIME)
    }

    /* Drops another square when the timer runs. */
    func newBlock() {
        if !game.gameOver {
            game.dropBlock()
            resetTimer(MAX_DROP_TIME)
        }
    }

    /* Indicates end of the timer. */
    func endTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        timer = nil;
    }
}