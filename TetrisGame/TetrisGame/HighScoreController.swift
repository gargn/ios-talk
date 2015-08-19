//
//  HighScoreController.swift
//  TetrisGame
//
//  Created by Rakina Zata Amni on 7/14/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import UIKit

/* View controller for the High Score view. */
class HighScoreController: UITableViewController {
    /* Loads values after the view loads. */
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Displays an Edit button in the navigation bar. */
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    /* Disposes any resources that can be created. */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* Defines number of sections in table view. */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /* Defines number of rows that need to be populated. */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLoader.getCount()
    }

    /* Defines a table view cell. */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath) as! PlayerCell
        let player = dataLoader.getPlayer(indexPath.row)

        cell.nameLabel.text = player.name
        cell.scoreLabel.text = String(player.score)
        return cell
    }

    /* Make delete remove a high score from the table. */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataLoader.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
