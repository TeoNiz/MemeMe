//
//  Meme.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 06.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText:String
    var bottomText:String
    var orginalImage:UIImage
    var memedImage:UIImage
    
    init(TopText:String,BottomText:String,OrginalImage:UIImage,MemedImage:UIImage)
    {
        topText=TopText
        bottomText=BottomText
        orginalImage=OrginalImage
        memedImage=MemedImage
    }
}