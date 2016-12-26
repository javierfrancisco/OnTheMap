//
//  MemeTextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by zenkiu on 8/7/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit


class LinkTextFieldDelegate: NSObject,  UITextFieldDelegate, UINavigationControllerDelegate {
    

    var inputLinkText : String?
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == inputLinkText){
            
            textField.text = ""
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        //print("In: textFieldShouldReturn")
        
        return true;
    }
    
}
