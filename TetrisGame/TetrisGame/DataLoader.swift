//
//  DataLoader.swift
//  TetrisGame
//
//  Created by Rakina Zata Amni on 7/14/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import Foundation

/* Global reference to DataLoader making the DataLoader a singleton. */
var dataLoader: DataLoader = DataLoader()

/* Loads the high scores. */
class DataLoader {
    private var firstLoad: BooleanType = true
    private var playersData: [Player] = []

    /* Writes the high scores to core data. */
    func writeData() {
        let gameData = NSKeyedArchiver.archivedDataWithRootObject(playersData)
        NSUserDefaults.standardUserDefaults().setObject(gameData, forKey: "GameData")
    }
    
    /* Reads the high scores from core data. */
    func readData() {
        let gameData = NSUserDefaults.standardUserDefaults().objectForKey("GameData") as? NSData
        if let gameData = gameData {
            playersData = NSKeyedUnarchiver.unarchiveObjectWithData(gameData) as! [Player]
        }
    }
    
    /* Loads players. */
    func loadPlayers() -> [Player] {
        if firstLoad {
            self.readData()
            firstLoad = false
        }
        return playersData
    }

    /* Returns the number of players. */
    func getCount() -> Int {
        return playersData.count
    }

    /* Returns the player. */
    func getPlayer(index: Int) -> Player {
        return playersData[index] as Player
    }

    /* Adds players data and stores it in the persistant data store. */
    func addPlayer(newPlayer : Player) {
        var index = 0
        while index < playersData.count && playersData[index].score > newPlayer.score {
            index++
        }
        playersData.insert(newPlayer, atIndex: index)
        dataLoader.writeData()
    }
    
    /* Removes score. */
    func removeAtIndex(index: Int) {
        playersData.removeAtIndex(index)
        writeData()
    }

    /* Reinitializing high scores. */
    func reinitializeHighScores() {
        playersData = []
        writeData()
    }
}