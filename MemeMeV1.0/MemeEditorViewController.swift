//
//  MemeEditorViewController.swift
//  MemeMeV1.0
//
//  Created by Maleina Bidek on 7/22/23.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    
    // MARK: Text Field Delegate
    let textFieldDelegate = TextFieldDelegate()
    
    //MARK: Constants
    // Meme text attribures dictionary
    // Some of this code is borrowed from Build V1.0 of the MemeMe App lesson
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -5.0
    ]
    
    // MARK: Actions
    @IBAction func pickAnImage(_ sender: Any) {
        pickMemeImage(sourceType: .photoLibrary)
    }
    
    @IBAction func takeAPicture(_ sender: Any) {
        pickMemeImage(sourceType: .camera)
    }
    
    // Generates and saves the meme, then presents the activity view controller so the meme can be shared
    @IBAction func shareAMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Clears and resets the screen
    @IBAction func cancelMeme(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        dismiss(animated: true, completion: nil)
        toggleTopButtons()
    }
    
    
    // MARK: Life Cycle Meethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default text and properties for meme text
        styleMemeText(textField: topTextField, defaultText: "TOP")
        styleMemeText(textField: bottomTextField, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Intial setup enable/disable buttons as necessary
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        toggleTopButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Delegate methods
    // Some of code in these next two methods was borrowed from Build V1.0 of the MemeMe App lesson
    
    // Gets the image chosen by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
                }
        dismiss(animated: true, completion: nil)
        toggleTopButtons()
    }
    
    // Dismisses the image picker if the user cancels
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper Methods
    
    // Meme text set up and styling
    func styleMemeText(textField: UITextField, defaultText: String) {
        textField.delegate = textFieldDelegate
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    // Let's the user pick an image from the selected source type (camera or album)
    func pickMemeImage (sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    // Some of the code in the remaining functions is from from Build V1.0 of the MemeMe App lesson
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // Pushes the image up so the keyboard doesn't hide the bottom text
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        // Pushes the image back down after the keyboard closes
        view.frame.origin.y = 0
    }
        
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save(memedImage: UIImage) {
            // Create the meme
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbars
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbars
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    func toggleTopButtons() {
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
            cancelButton.isEnabled = true
        }
    }
    
}
