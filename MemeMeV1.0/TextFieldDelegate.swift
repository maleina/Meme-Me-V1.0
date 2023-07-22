//
//  TextFieldDelegate.swift
//  MemeMeV1.0
//
//  Created by Maleina Bidek on 7/22/23.
//

import Foundation
import UIKit

class TextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Remove any default text
        if (textField.text == "TOP") || (textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Automatically close the keyboard if return is pressed
        textField.resignFirstResponder()
        return true
    }
}
