//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 03.10.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController{
    
    @IBOutlet weak var memedImage: UIImageView!
    let database=MemesDatabase.sharedInstance
    var memeIndexInDatabase:Int?
    
    public func setWhatMemeIsDesplayed(indexOfMeme:Int)
    {
        memeIndexInDatabase = indexOfMeme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let meme=database.getMeme(index: memeIndexInDatabase!)
        memedImage.image=meme?.memedImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier=="ToEdit")
        {
            let destination = segue.destination as! MemeEditorViewController
            destination.setWhatMemeIsAboutToBeEdite(indexOfMeme: memeIndexInDatabase!)
        }
    }
    
}
