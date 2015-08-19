//
//  Store.swift
//  TetrisGame
//
//  Created by Curtis Fenner on 7/15/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import Foundation

/**
* General notes on authorization:
*    Use the following command to determine the JSON payments for the account:
*       curl -H "Authorization: Bearer <token>" https://connect.squareup.com/v1/me/payments
*    The application pretends they are all developing as the owner of the merchant account.
*/

/* Global reference to Store making the Store a singleton. */
var store = Store()

/* Allow dates to be formatted as RFC3339, the time format that the Connect API uses.
 * From Stackoverflow */
extension NSDate {
    var rfc3339: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.stringFromDate(self)
    }
}

/* Returns a randomly shuffled version of the input list.
 * From stackoverflow. */
func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let c = count(list)
    if c < 2 {
        return list
    }
    for i in 0..<(c - 1) {
        let j = Int(arc4random_uniform(UInt32(c - i))) + i
        swap(&list[i], &list[j])
    }
    return list
}

/* Represents the payments coming in from the store. */
class Store : NSObject {
    
    /* Time of last payment taken from the server */
    private var timeCutoff = NSDate().rfc3339
    
    /* Blocks available for user. */
    private var cart: [Character] = []
    
    /* Indicates no purchases have been processed. */
    private var initialized = false
    
    private override init() {
        super.init()
    }
    
    /* Begin tracking sales on Square register by the Square Connect API */
    func initialize() {
        if !initialized {
            checkForPurchases(nil)
        }
    }
    
    /* Tells the store that a block was purchased. Give it the name of the item.
     * <Implementation: Only cares about the final letter of the name>. */
    func purchase(itemName: String) {
        println("Purchased [[" + itemName + "]]")
        cart.append(itemName[itemName.endIndex.predecessor()])
    }
    
    /* Returns a character corresponding to the next block that was bought
     * (or nil if you need to buy more blocks). */
    func nextBlock() -> Character? {
        if cart.count > 0 {
            let block = cart.removeAtIndex(0)
            println("Removed " + String(block))
            return block
        }
        return nil
    }

    /* Requests all new payments from Connect. Called in sequence.
     * Only one should be running at a time. */
    func checkForPurchases(error: NSError?) {
        /* Request all payments in the last year, most recent first. */
        connect("payments?order=DESC&begin_time=" + timeCutoff, receivePayments, checkForPurchases)
    }
    
    /* Parses data returned from the Connect list payments endpoint. */
    private func receivePayments(data: NSData) {
        /* Payments contains the data parsed through JSObject. */
        let payments = JSObject(data: data)

        /* Ignore all payments prior to the game start and establish latest payment during game. */
        for payment in payments {
            /* DOC: https://docs.connect.squareup.com/api/connect/v1/#datatype-payment */
            /* List of all item names in this purchase */
            var itemNames: [String] = []

            /* Get the "itemizations" on this payment (list of all items purchased). */
            let itemizations = payment["itemizations"]

            /* Iterates through items. */
            /* DOC: https://docs.connect.squareup.com/api/connect/v1/#datatype-paymentitemization */
            /* Hint: Use parseInt() for quantitiy instad of parsing as a double. */

            /* Shuffle all items purchased (they're grouped by quantity and sorted alphabetically). */
            itemNames = shuffle(itemNames)
            for name in itemNames {
                /* Only count items called labeled with 'Tetramino'. */
                if name.rangeOfString("Tetramino") != nil {
                    /* Tell the Store that this was bought. */
                    purchase(name)
                }
            }
        }

        /* Update the cutoff point at lastPaymentToken to the most recent payment id. */
        if payments.length() > 0 {
            if let created_at = payments[0]["created_at"].string() {
                timeCutoff = created_at
            }
        }
        checkForPurchases(nil)
    }
}
