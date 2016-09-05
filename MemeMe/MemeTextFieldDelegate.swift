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
    
    var textInsideIsDefault:Bool=true
    
    func textFieldDidBeginEditing(textField: UITextField){
        if(textInsideIsDefault)
        {
            //textField.text=""
            //textInsideIsDefault=false
            //TODO: clear default text but only default!
        }
    }
    
    /*func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //TODO: add code tohidde keyboard when user press return
        return true
    }*/
}