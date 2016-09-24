//
//  MemsDatabase.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 23.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation


// singleton from: http://krakendev.io/blog/the-right-way-to-write-a-singleton
class MemsDatabase{
    static let sharedInstance = MemsDatabase()
    private init() {}

    private var allMems = [Meme]()
    
    func addMeme(meme:Meme) {
        allMems.append(meme)
    }
    
    func getNumberOfMems() -> Int{
        return allMems.count
    }
}

