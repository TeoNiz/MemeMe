//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 25.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var memeCollectionView: UICollectionView!

    let database=MemesDatabase.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.memeCollectionView.
     //   tableHeaderView=UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.memeTableView.bounds.size.width, height: 0.01))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell",for: indexPath)
        
        let meme=database.getMeme(index: indexPath.row)
        if let meme=meme{
            cell.backgroundView=UIImageView(image: meme.memedImage)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return database.getNumberOfMems();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

    }
}
