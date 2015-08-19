//
//  Connect.swift
//  TetrisGame
//
//  Created by Curtis Fenner on 7/15/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import Foundation

/* Load the secret from an UNTRACKED file. */
private let mainBundle = NSBundle.mainBundle()
private let paTokenPath = mainBundle.pathForResource("personal-access-token", ofType: "txt")
private let SECRET = NSString(contentsOfFile: paTokenPath!, encoding: NSASCIIStringEncoding, error: nil)! as! String

/* Calls callback with the data returned by the request.
 *
 * Calls errorCallback if the request can't be completed because of an error 
 * (Ex. you are disconnected from the internet).
 */
private func httpGet(request: NSURLRequest!, callback: (NSData) -> Void, errorCallback: (NSError) -> Void) {
    var session = NSURLSession.sharedSession()
    var task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        if error != nil {
            /* Calls error callback in case request can't be completed. */
            println(error)
            errorCallback(error!)
        } else {
            /* Calls callback to parse list of payments. */
            callback(data!)
        }
    }
    task.resume()
}

/* Ask Connect API for information for my account.
 *
 * connect("payments") returns a list of all the payments.
 * callback - A function that takes in the JSON response.
 *            Performs the JSON parsing.
 * errorCallback - Called if the request can't be completed.
 *                 (Ex. you are not connected to the internet).
 */
func connect(path: String, callback: (NSData) -> (), errorCallback: (NSError) -> ()) {
    var request = NSMutableURLRequest(URL: NSURL(string: "https://connect.squareup.com/v1/me/" + path)!)
    request.addValue("Bearer " + SECRET, forHTTPHeaderField: "Authorization")
    /* Makes an http request. */
    httpGet(request, callback, errorCallback)
}
