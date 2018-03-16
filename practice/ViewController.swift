//
//  ViewController.swift
//  practice
//
//  Created by Yohan Yi on 2017. 4. 28..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var CameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var topToolBar: UIToolbar!
    
    var meme:Meme!
    
    //reset to default
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        topTextField.endEditing(true)
        bottomTextField.endEditing(true)
    }
    
    //Defult Attributes for Text Field
    let memeTextAttribues = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(value: -3.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // configure(textfield: topTextField, text: "TOP")
        configure(textfield: bottomTextField, text: "Place Your Memo")
    }
    
    func configure(textfield: UITextField, text: String){
        
        textfield.delegate = self
        //Text Field's Defult Text
        textfield.text = text
        //Asign Text Field's Attributes
        textfield.defaultTextAttributes = memeTextAttribues
        
        textfield.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Subscribe to Keyboard notification
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        //Check Camera is available
        CameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func viewWillDisapear(_ animated: Bool){
        // Unsubscribe to Keyboard notification
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //Move the view when the keyboard covers the text field
    func keyboardWillShow(notification: NSNotification){
        if bottomTextField.isFirstResponder{
            self.view.frame.origin.y = 0 - getKeyboardHeight(notification as Notification)
        }
    }
    
    //Return to nomal view when keyboard is hide
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
     //Add an observer for KB notification
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Remove thoses observer
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Function that clear text field when user start typing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topTextField && topTextField.text == "TOP") {
            topTextField.text = ""
        } else if (textField == bottomTextField && bottomTextField.text == "BOTTOM") {
            bottomTextField.text = ""
        }
    }
    
    //Function that allows the user to use the return key to escape from the text input
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* Actions for #1 Album and #2 Camera Button */
 
    // #1 Pick Image from Library
    @IBAction func pickAnImage (_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    // #2 Choose Image from Camera
    @IBAction func imageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Assign the image to UIImageView from #1 or #2
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // To cancel selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        toolBar.isHidden = true
        topToolBar.isHidden = true
        //topTextField.endEditing(true)
        bottomTextField.endEditing(true)
        
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        topToolBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func shareImage(_ sender: Any) {

        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func save() {
        let memedImage = generateMemedImage()
        //Create the meme
        let meme = Meme(topText: "", botText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        self.meme = meme
        (UIApplication.shared.delegate as! AppDelegate).memes.append(self.meme)
    }
}

