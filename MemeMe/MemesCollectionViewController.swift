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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let database=MemesDatabase.sharedInstance
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeFlowLayoutItemSize()
        memeCollectionView.reloadData()
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

        let editingViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editingViewController.setWhatMemeIsAboutToBeEdite(indexOfMeme: indexPath.row)
        self.navigationController!.pushViewController(editingViewController, animated: true)
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        changeFlowLayoutItemSize()
    }
    
    func changeFlowLayoutItemSize()
    {
        let space: CGFloat = 1.0
        let numberOfItemsInRow: CGFloat = 4.0
        let dimension = (self.view.frame.size.width - ((numberOfItemsInRow - 1.0) * space)) / numberOfItemsInRow
        flowLayout.minimumLineSpacing=space
        flowLayout.minimumInteritemSpacing=space
        flowLayout.itemSize=CGSize(width: dimension, height: dimension)
    }
    
}
