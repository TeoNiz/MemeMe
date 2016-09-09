//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Teodor Niżyński on 05.09.2016.
//  Copyright © 2016 Teodor Niżyński. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickFromAlbumButton: UIBarButtonItem!
    @IBOutlet weak var pickFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    
    var keyboardIsUp:Bool=false
    let MemeTextDelegate=MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldAtrributes(TopTextField, initialText: "TOP")
        setTextFieldAtrributes(BottomTextField, initialText: "BOTTOM")
        shareButton.enabled=false
    }

    func setTextFieldAtrributes(textField:UITextField, initialText:String){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -3.0,
        ]
        textField.text=initialText
        textField.delegate=MemeTextDelegate
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
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //solution from: https://discussions.udacity.com/t/keyboard-adjustment-for-bottom-text-but-not-top-text/33454/2
        if (BottomTextField.isFirstResponder() && keyboardIsUp==false) {
            keyboardIsUp=true
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        view.frame.origin.y=0
        keyboardIsUp=false
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func pickImage(sender: AnyObject){
        let imagePicker=UIImagePickerController()
        imagePicker.delegate = self //TODO: get rid of self, but what insteed?
        if(sender as! NSObject==pickFromCameraButton){
            imagePicker.sourceType=UIImagePickerControllerSourceType.Camera
        }
        if(sender as! NSObject==pickFromAlbumButton){
            imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        }
            presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            imagePickerView.image = image
        }
        setShareButtonState()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController){
        setShareButtonState()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setShareButtonState() {
        if(imagePickerView.image==nil){
            shareButton.enabled=false
        }
        else{
            shareButton.enabled=true
        }
    }
    
    @IBAction func shareMeme(){
        let memdImage=combineImageAndText()
        let nextController = UIActivityViewController(activityItems: [memdImage], applicationActivities: nil)
        //preventing crash on ipad - solution from http://stackoverflow.com/questions/33280518/ios-uiactivityviewcontroller
        //still crashes on simulator when I try to send mail - is taht problem? or https://forums.developer.apple.com/thread/4415
        nextController.popoverPresentationController?.sourceView = view
        nextController.completionWithItemsHandler={
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed{
                self.saveMeme(memdImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(nextController, animated: true, completion: nil)
    }
    
    func saveMeme(memedImage:UIImage){
        let meme=Meme(topText: TopTextField.text!, bottomText: BottomTextField.text!, orginalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    func combineImageAndText() -> UIImage {
        
        bottomToolBar.hidden=true
        topNavigationBar.hidden=true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        bottomToolBar.hidden=false
        topNavigationBar.hidden=false
        
        
        return memedImage
    }

}

