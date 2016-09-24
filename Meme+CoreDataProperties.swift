//
//  Meme+CoreDataProperties.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 24.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import CoreData


extension Meme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meme> {
        return NSFetchRequest<Meme>(entityName: "Meme");
    }

    @NSManaged public var topText: String?
    @NSManaged public var rawImageData: NSData?
    @NSManaged public var bottomText: String?
    @NSManaged public var memedImageData: NSData?

}
