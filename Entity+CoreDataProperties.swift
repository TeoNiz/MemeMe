//
//  Entity+CoreDataProperties.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 24.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import CoreData


public class Entity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity");
    }

    @NSManaged public var topText: String?
    @NSManaged public var bottomText: String?
    @NSManaged public var rawImage: NSData?
    @NSManaged public var memedImage: NSData?

}
