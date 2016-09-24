//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 05.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var topTextFieldHasDefaultText:Bool=true
    var bottomTextFieldHasDefaultText:Bool = true
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if(topTextFieldHasDefaultText==true && textField.tag==0)
        {
            textField.text=""
            topTextFieldHasDefaultText=false
        }
        else if(bottomTextFieldHasDefaultText==true && textField.tag==1)
        {
            textField.text=""
            bottomTextFieldHasDefaultText=false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
       textField.resignFirstResponder()
        return true
    }
}
