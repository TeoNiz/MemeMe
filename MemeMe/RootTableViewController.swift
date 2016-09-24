//
//  RootTableViewController.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 24.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import UIKit

class RootTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Udalo sie wczytac!")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MemesCells")!
        cell.textLabel!.text = "Main Text"
        cell.detailTextLabel!.text = "Detailed Text"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
