//
//  ViewController.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 05.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pickImage(sender: AnyObject){
        let imagePicker=UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        print("We picked something!")
        print(info.description)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController){
        print("Och noes pick was canceled!")
        dismissViewControllerAnimated(true, completion: nil)
    }

}

