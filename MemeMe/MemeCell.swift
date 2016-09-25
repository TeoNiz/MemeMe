//
//  MemeCell.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 25.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import UIKit

class MemeCell : UITableViewCell {
    
    @IBOutlet weak var TopTextLabel: UILabel?
    @IBOutlet weak var BottomTextLabel: UILabel?
    @IBOutlet weak var MemeImage: UIImageView?

    func setMeme(topText:String,bottomText:String,memeImage:UIImage){
        TopTextLabel?.text=topText
        BottomTextLabel?.text=bottomText
        MemeImage?.image=memeImage
    }
}
