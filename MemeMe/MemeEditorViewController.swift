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
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var saveAndLeaveButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var keyboardIsUp:Bool=false
    let MemeTextDelegate=MemeTextFieldDelegate()
    var freshMeme=true
    var editingMemeOfNumber:Int?
    
    // MARK: Initial procedure and methods
    
    public func setWhatMemeIsAboutToBeEdite(indexOfMeme:Int)
    {
        editingMemeOfNumber = indexOfMeme
        freshMeme = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(freshMeme){
            setTextFieldAtrributes(TopTextField, initialText: "TOP")
            setTextFieldAtrributes(BottomTextField, initialText: "BOTTOM")
        }
        else{
            let meme = MemesDatabase.sharedInstance.getMeme(index: editingMemeOfNumber!)!
            setTextFieldAtrributes(TopTextField, initialText: meme.topText)
            setTextFieldAtrributes(BottomTextField, initialText: meme.bottomText)
            imagePickerView.image=meme.orginalImage
        }
        setShareButtonState()
        shareButton.target=self
        shareButton.action=#selector(MemeEditorViewController.shareMeme)
        saveAndLeaveButton.target=self
        saveAndLeaveButton.action=#selector(MemeEditorViewController.saveMemeAndLeave)
    }

    func setTextFieldAtrributes(_ textField:UITextField, initialText:String){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSStrokeWidthAttributeName : -3.0,
        ] as [String : Any]
        textField.text=initialText
        textField.delegate=MemeTextDelegate
        textField.defaultTextAttributes=memeTextAttributes
        textField.borderStyle=UITextBorderStyle.none
        textField.textColor=UIColor.white
        textField.font=UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        textField.textAlignment=NSTextAlignment.center
        textField.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pickFromCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: keyboard
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        //solution from: https://discussions.udacity.com/t/keyboard-adjustment-for-bottom-text-but-not-top-text/33454/2
        if (BottomTextField.isFirstResponder && keyboardIsUp==false) {
            keyboardIsUp=true
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y=0
        keyboardIsUp=false
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: picking Image
    
    @IBAction func pickImage(_ sender: AnyObject){
        let imagePicker=UIImagePickerController()
        imagePicker.delegate = self
        if(sender as! NSObject==pickFromCameraButton){
            imagePicker.sourceType=UIImagePickerControllerSourceType.camera
        }
        if(sender as! NSObject==pickFromAlbumButton){
            imagePicker.sourceType=UIImagePickerControllerSourceType.photoLibrary
        }
            present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            imagePickerView.image = image
        }
        setShareButtonState()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        setShareButtonState()
        dismiss(animated: true, completion: nil)
    }
    
    func setShareButtonState() {
        if(imagePickerView.image==nil){
           shareButton.isEnabled=false
           saveAndLeaveButton.isEnabled=false
        }
        else{
           shareButton.isEnabled=true
           saveAndLeaveButton.isEnabled=true
        }
    }
    
    @IBAction func shareMeme(){
        let memdImage=combineImageAndText()
        let nextController = UIActivityViewController(activityItems: [memdImage], applicationActivities: nil)
        //preventing crash on ipad - solution from http://stackoverflow.com/questions/33280518/ios-uiactivityviewcontroller
        //still crashes on simulator when I try to send mail - is taht problem? or https://forums.developer.apple.com/thread/4415
        nextController.popoverPresentationController?.sourceView = view
        nextController.completionWithItemsHandler={(activity:UIActivityType?, completed:Bool, items:[Any]?, error: Error?) -> Void in
            if completed{
                self.saveMeme(memdImage)
                self.dismiss(animated: true, completion: nil)
                self.leave()
            }
        }
        present(nextController, animated: true, completion: nil)
    }
    
    func saveMeme(_ memedImage:UIImage){
        let meme=Meme(topText: TopTextField.text!, bottomText: BottomTextField.text!, orginalImage: imagePickerView.image!, memedImage: memedImage)
        if(freshMeme){
            MemesDatabase.sharedInstance.addMeme(meme:meme)
        }
        else{
            MemesDatabase.sharedInstance.editMeme(meme:meme, atIndex:editingMemeOfNumber!)
        }
    }
    
    func saveMemeAndLeave()
    {
        let memdImage=combineImageAndText()
        saveMeme(memdImage)
        leave()
    }
    
    func leave()
    {
        //solution from: http://stackoverflow.com/questions/12561735/what-are-unwind-segues-for-and-how-do-you-use-them
        performSegue(withIdentifier: "UnwindToMemeList", sender: nil)

    }
    
    func combineImageAndText() -> UIImage {
        
        setToolbarStateToInvisable(as: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setToolbarStateToInvisable(as: false)
        return memedImage
    }

    func setToolbarStateToInvisable(as active:Bool){
        self.navigationController?.isToolbarHidden=active
        bottomToolBar.isHidden=active
    }
    
}

