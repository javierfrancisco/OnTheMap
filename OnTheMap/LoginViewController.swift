//
//  ViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/19/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         passwordTextField.delegate = self
         usernameTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginToTheApp(_ sender: Any) {
        

        var credentials = [String : String]()
        credentials[UdacityClient.ParametersKeys.Username] = self.usernameTextField.text
        credentials[UdacityClient.ParametersKeys.Password] = self.passwordTextField.text
        
        UdacityClient.sharedInstance().authenticateWithCredentials(credentials: credentials as [String : AnyObject]){ (success, errorString) in
            
            print("authentication call completed>")
            
            performUIUpdatesOnMain {
                if success {
                    print("success> \(UdacityClient.sharedInstance().sessionID)")
                    self.completeLogin()
                } else {
                    print("error>")
                    self.showErrorAlert(errorString!)
                }
            }
        }
        
        
       
    }
    
    func validateLoginData( username : String, password : String , completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        if(username == "" || password  == "" ){
            
            completionHandlerForAuth(false, "Empty Email or Password")
            
        }else{
        
            completionHandlerForAuth(true, nil)
        }
    }
    
    func showErrorAlert(_ error : String){
    
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func completeLogin(){
    
          performSegue(withIdentifier: "showOnTheMap", sender: self)
    }
    
    func displayError(_ error: String){
    
        print(":::\(error)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}

