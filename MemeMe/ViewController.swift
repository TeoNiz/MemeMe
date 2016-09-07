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
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    
    
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
        textField.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pickFromCameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("Patrze co sie tutaj dzieje")
        print(notification.name)
        print(notification.object)
        //solution from: https://discussions.udacity.com/t/keyboard-adjustment-for-bottom-text-but-not-top-text/33454/2
        if BottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        view.frame.origin.y=0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
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
    
    @IBAction func shareMeme(){
        let memdImage=combineImageAndText()
        let nextController = UIActivityViewController(activityItems: [memdImage], applicationActivities: nil)
        //preventing crash on ipad - solution from http://stackoverflow.com/questions/33280518/ios-uiactivityviewcontroller
        //still crashes on simulator when I try to send mail - is taht problem? or https://forums.developer.apple.com/thread/4415
        nextController.popoverPresentationController?.sourceView = self.view
        nextController.completionWithItemsHandler={
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed{
                self.saveMeme(memdImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    func saveMeme(memedImage:UIImage){
        let meme=Meme(TopText: TopTextField.text!, BottomText: BottomTextField.text!, OrginalImage: imagePickerView.image!, MemedImage: memedImage)
    }
    
    func combineImageAndText() -> UIImage {
        
        //TODO: Hide toolbar and navbar
        bottomToolBar.hidden=true
        topNavigationBar.hidden=true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar       
        bottomToolBar.hidden=false
        topNavigationBar.hidden=false
        
        
        return memedImage
    }

}

