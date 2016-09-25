//
//  MemesDatabase.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 23.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import UIKit
import Foundation
import CoreData

// Singleton from: http://krakendev.io/blog/the-right-way-to-write-a-singleton
// CordeData from: http://www.codebeaulieu.com/10/adding-core-data-using-swift-2

class MemesDatabase{
    static let sharedInstance = MemesDatabase()
    private init(){
        getAllMemes()
    }

    private let moc=DataController().managedObjectContext
    private var allMems = [Meme]()
    
    func addMeme(meme:Meme) {
        allMems.append(meme)
        saveMemeToDatabase(meme: meme)
    }
    
    func getNumberOfMems() -> Int{
        return allMems.count
    }
    
    func getMeme(index:Int) -> Meme?{
        if(index<(allMems.count) && index>=0)
        {
            return allMems[index]
        }
        return nil
    }
    
    private func saveMemeToDatabase(meme:Meme){
        
        let entity=NSEntityDescription.insertNewObject(forEntityName: "Entity", into: moc) as! Entity
        
        entity.setValue(meme.topText, forKey: "topText")
        entity.setValue(meme.bottomText, forKey: "bottomText")
        
        let rawImageData:Data = UIImagePNGRepresentation(meme.orginalImage)!
        let memedImageData:Data=UIImagePNGRepresentation(meme.memedImage)!
        
        entity.setValue(rawImageData, forKey: "rawImage")
        entity.setValue(memedImageData, forKey: "memedImage")
        
        do{
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
    
    private func getAllMemes(){
        let moc = DataController().managedObjectContext
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            let fetchedEntities = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [Entity]
            for entity in fetchedEntities{
                let orginalImage : UIImage = UIImage(data: entity.rawImage as! Data)!
                let memedImage : UIImage = UIImage(data: entity.memedImage as! Data)!
                let meme=Meme(topText: entity.topText!, bottomText: entity.bottomText!, orginalImage: orginalImage, memedImage: memedImage)
                allMems.append(meme)
                //print("Getting meme: \(entity.topText) \(entity.bottomText)")
            }
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    private func deleteMeme(){
        //http://stackoverflow.com/questions/31859306/ios-how-to-delete-an-object-in-core-data-swift
    }
}

