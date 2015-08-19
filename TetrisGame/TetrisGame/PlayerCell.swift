//
//  PlayerCell.swift
//  TetrisGame
//
//  Created by Rakina Zata Amni on 7/14/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import Foundation
import UIKit

/* Defines a cell that displays the player's scores. */
class PlayerCell: UITableViewCell {
    /* Label containing name. */
    @IBOutlet weak var nameLabel: UILabel!
    
    /* Label containing score. */
    @IBOutlet weak var scoreLabel: UILabel!
}