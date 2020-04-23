//
//  Helper.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
    
    static func setImagePicker(type: UIImagePickerController.SourceType, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        print("Type: ",type)
        imagePicker.delegate = delegate
        imagePicker.sourceType = type
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    static func setDatePicker(datePicker: UIDatePicker, txtField: UITextField,firstAction: Selector,secondAction: Selector) -> UIDatePicker{
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: firstAction)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: secondAction)
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        // add toolbar to textField
        txtField.inputAccessoryView = toolbar
        // add datepicker to textField
        txtField.inputView = datePicker
        return datePicker
    }
    
    static func makeWarningAlert(title: String,message: String) -> UIAlertController{
        let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    static func makeImagePickerAlert(firstAction:@escaping () -> (),secondAction: @escaping () -> ()) -> UIAlertController{
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { alert in
            firstAction()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { alert in
            secondAction()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    static func makeEmptyTextAlert()-> UIAlertController {
        let alert  = UIAlertController(title: "Warning", message: "Fill in all required fields!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    static func makeAddedPeopleAlert(name: String) -> UIAlertController {
        let alert  = UIAlertController(title: "Success", message: "You added "+name+" to your list!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    static func makeEditedPeopleAlert(name: String) -> UIAlertController {
        let alert  = UIAlertController(title: "Success", message: "You edited "+name+" in your list!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}

