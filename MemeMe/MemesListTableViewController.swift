//
//  MemesListTableViewController.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 24.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import UIKit

class MemesListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    //tabBar Images from: https://www.iconfinder.com/icons/103174/list_menu_icon#size=128 and https://www.iconfinder.com/icons/126570/grid_icon#size=128
    
    @IBOutlet weak var memeTableView: UITableView!
    let database=MemesDatabase.sharedInstance
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        memeTableView.reloadData()
        self.navigationController?.isToolbarHidden=true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.getNumberOfMems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MemesCells")! as! MemeCell
        
        let meme=database.getMeme(index: indexPath.row)
        if let meme=meme{
            cell.setMeme(topText: meme.topText, bottomText: meme.bottomText, memeImage: meme.memedImage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let nextViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        nextViewController.setWhatMemeIsDesplayed(indexOfMeme: indexPath.row)
        self.navigationController!.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func unwindToMemesList(segue: UIStoryboardSegue){
        
    }
}
