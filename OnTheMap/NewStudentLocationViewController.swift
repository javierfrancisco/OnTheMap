//
//  NewStudentLocationViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/27/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit



class NewStudentLocationViewController :  UIViewController, UITextFieldDelegate, UINavigationControllerDelegate  {
    
    
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    var studentLocations = [ParseStudentLocation]()
    
    @IBAction func findOnMap(_ sender: Any) {
   
    
        print("in findOnMap")
        
         performSegue(withIdentifier: "onTheMapDetail", sender: self)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("in NewStudentLocationViewController_viewDidLoad")
        
        prepareTextField(textField: locationTextField, defaultText: "Enter your location here")
        
        self.subscribeToKeyboardNotifications()
        
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
   
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!
            ] as [String : Any]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text=defaultText
        
    }

    
    func subscribeToKeyboardNotifications() {
        
        print("IN-->subscribeToKeyboardNotifications")
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewStudentLocationViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewStudentLocationViewController.keyboardWillHide(notification:))   , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    var keyboardHeight : CGFloat = 0.0
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("IN-->keyboardWillShow")
        
        
        keyboardHeight=getKeyboardHeight(notification: notification)
            
        view.frame.origin.y =  getKeyboardHeight(notification: notification) * -1
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // print("IN-->keyboardWillHide")
        
        self.view.frame.origin.y += keyboardHeight
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        //print("IN-->getKeyboardHeight")
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        //print("IN-->getKeyboardHeight2: \( keyboardSize.cgRectValue.height)")
        return keyboardSize.cgRectValue.height
    }
    
    
    @IBAction func performCancelAction(_ sender: Any) {
        
        dismiss(animated: true,  completion: nil)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
        
        
}
