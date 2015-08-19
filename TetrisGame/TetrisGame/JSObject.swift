//
//  JSON.swift
//  TetrisGame
//
//  Created by Curtis Fenner on 7/15/15.
//  Copyright (c) 2015 Square. All rights reserved.
//

import Foundation

/* Creates a JSON object. */
class JSObject : SequenceType {
    private var error: String?
    private var underlying: AnyObject?

    /* Creates a JSON object with the NSData provided. */
    init(data: NSData) {
        underlying = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
    }

    /* Private constructor indicating an error through a JSON object. */
    private init(err: String) {
        error = err
    }

    /* Private constructor creates an AnyObject from the rest of the data parsed. */
    private init(un: AnyObject?) {
        underlying = un
    }

    /* Returns a JSObject that represents a dictionary */
    subscript(index: String) -> JSObject {
        if error != nil {
            return JSObject(err: error! + "[" + index + "]")
        }
        if let dictionary = underlying as? NSDictionary {
            if let value: AnyObject = dictionary[index] {
                return JSObject(un: value)
            } else {
                return JSObject(err: "<dictionary[" + index + "] does not exist>")
            }
        } else {
            return JSObject(err: "<not a dictionary>[" + index + "]")
        }
    }

    /* Reuturns a JSObject that represents a list. */
    subscript(index: Int) -> JSObject {
        if error != nil {
            return JSObject(err: error! + "[" + String(index) + "]")
        }
        if let array = underlying as? NSArray {
            if index >= array.count {
                return JSObject(err: "<index " + String(index) + " is out of bounds (array length " + String(array.count) + ")>")
            }
            if index < 0 {
                return JSObject(err: "<index " + String(index) + " cannot be negative>")
            }
            return JSObject(un: array[index])
        } else {
            return JSObject(err: "<not an array>[" + String(index) + "]")
        }
    }

    /* Returns an iterator for a JSObject for lists. */
    func generate() -> GeneratorOf<JSObject> {
        complain(" used in for .. in")
        if let _ = underlying as? NSArray{
            var index = 0
            return GeneratorOf<JSObject> {
                if index >= self.length() {
                    return nil
                }
                index++
                return self[index-1]
            }
        } else {
            return GeneratorOf<JSObject> {
                return nil
            }
        }
    }

    /* Parses a string out of a JSON Object. */
    func string() -> String? {
        complain(".string()")
        return underlying as? String
    }

    /* Parses a double out of a JSON Object. */
    func double() -> Double? {
        complain(".double()")
        return underlying as? Double
    }

    /* Parses a double out of a String in a JSON object */
    func parseDouble() -> Double? {
        complain(".parseDouble()")
        if let str = underlying as? NSString {
            return str.doubleValue
        }
        return nil
    }

    /* Parses an integer out a String in a JSON object */
    func parseInt() -> Int? {
        complain(".parseInt()")
        let x = parseDouble()
        if x == nil {
            return nil
        }
        if floor(x!) == x! {
            return Int(x!)
        }
        return nil
    }

    /* Determines length of a JSON array. */
    func length() -> Int {
        complain(".length()")
        if let array = underlying as? NSArray {
            return array.count
        }
        return 0
    }

    /* Returns whether or not an error has occurred in the JSON by determining if error is nil */
    func invalid() -> String? {
        return error
    }
    
    /* Prints errors if there is invalid JSON. */
    func complain(suffix: String) {
        if error != nil {
            println("Got nil value from invalid JSObject: " + error! + suffix)
        }
    }
}
