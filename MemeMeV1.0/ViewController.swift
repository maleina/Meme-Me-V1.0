//
//  ViewController.swift
//  MemeMeV1.0
//
//  Created by Maleina Bidek on 7/22/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // This code was borrowed from Build V1.0 of the MemeMe App lesson
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
            present(pickerController, animated: true, completion: nil)
    }
    
}

