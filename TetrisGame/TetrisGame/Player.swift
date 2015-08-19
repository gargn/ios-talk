//
//  Player.swift
//  TetrisGame
//
//  Created by Rakina Zata Amni on 7/14/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import UIKit

/* Defines a player object.
 *
 * NSCoding allows the information to be stored across uses. */
class Player: NSObject, NSCoding {
    var name: String
    var score: Int

    /* Initializes a Player. */
    init(name: String, score: Int) {
        self.name = name
        self.score = score
        super.init()
    }

    /* Translates the NSCoder object into a Player object. */
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        score = aDecoder.decodeIntegerForKey("score")
    }

    /* Translates the Player object into an NSCoder object. */
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInteger(score, forKey: "score")
    }
}

