//
//  ViewController.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 05.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickFromAlbumButton: UIBarButtonItem!
    @IBOutlet weak var pickFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    
    let MemeTextDelegate=MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TopTextField.text="TOP"
        BottomTextField.text="BOTTOM"
        
        setTextFieldAtrributes(TopTextField)
        setTextFieldAtrributes(BottomTextField)
        
        TopTextField.delegate=MemeTextDelegate
        BottomTextField.delegate=MemeTextDelegate

    }

    func setTextFieldAtrributes(textField:UITextField){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -3.0,
            
        ]
        textField.defaultTextAttributes=memeTextAttributes
        textField.borderStyle=UITextBorderStyle.None
        textField.textColor=UIColor.whiteColor()
        textField.font=UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        textField.textAlignment=NSTextAlignment.Center
        //textField.
        textField.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pickFromCameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pickImage(sender: AnyObject){
        print(sender)
        let imagePicker=UIImagePickerController()
        imagePicker.delegate = self

        if(sender as! NSObject==pickFromCameraButton){
            imagePicker.sourceType=UIImagePickerControllerSourceType.Camera
        }
        if(sender as! NSObject==pickFromAlbumButton){
            imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        print("We picked something!")
        print(info.description)
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            imagePickerView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController){
        print("Och noes pick was canceled!")
        dismissViewControllerAnimated(true, completion: nil)
    }

}

