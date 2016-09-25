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

    let database=MemesDatabase.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
}
