//
//  StudentLocationOnMapViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/27/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit



class StudentLocationOnMapViewController :  UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("in StudentLocationOnMapViewController viewDidLoad ")
        
    }
    @IBAction func performCancelAction(_ sender: Any) {
        
        
       
        dismiss(animated: true, completion:  nil)
        //performSegue(withIdentifier: "unwind", sender: nil)
        
        
    }
    
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {
    
        print("in myUnwindAction ")
    }
}
    
