//
//  ViewController.swift
//  MemeMeV1.0
//
//  Created by Maleina Bidek on 7/22/23.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    
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
    
    // The code in these methids was borrowed from Build V1.0 of the MemeMe App lesson
    @IBAction func pickAnImage(_ sender: Any) {
        pickMemeImage(sourceType: .photoLibrary)
    }
    @IBAction func takeAPicture(_ sender: Any) {
        pickMemeImage(sourceType: .camera)
    }
    
    // MARK: Life Cycle Meethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default text and properties for meme text
        styleMemeText(textField: topTextField, defaultText: "TOP")
        styleMemeText(textField: bottomTextField, defaultText: "BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK: Delegate methods
    
    // The code in these methids was borrowed from Build V1.0 of the MemeMe App lesson
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    imagePickerView.image = image
                }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper Methods
    
    func styleMemeText(textField: UITextField, defaultText: String) {
        textField.delegate = textFieldDelegate
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func pickMemeImage (sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
}

