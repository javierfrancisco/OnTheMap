//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by zenkiu on 11/24/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import UIKit
import Foundation

// (Convenient Resource Methods)

extension UdacityClient {
    
    func logout( sessionId : String, completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void){
    
        let _ = logoutFromUdacity(sessionId: sessionId){
            success , errorString in
            
            if success {
            
                completionHandlerForLogout(true,nil)
            }else{
                completionHandlerForLogout(false, "Error in logout")
            }
        }
    }


    /*
     Steps for Authentication...
     
     Step 1: Create a new sessionId, and get the user's key
     Step 2: Get the Udacity User by key
     */
    func authenticateWithCredentials(credentials: [String:AnyObject], completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        let username = credentials[UdacityClient.ParametersKeys.Username] as? String
        let password = credentials[UdacityClient.ParametersKeys.Password] as? String
        
        //Client Side validation befor calling server
        validateLoginData(username: username!, password: password!){ success, error in
            
            func displayError(_ error: String, errorDetail : String){
                
                print(errorDetail)
                completionHandlerForAuth(false, error)
            }
            
            if error != nil {
                displayError( error! , errorDetail: error! )
            }
            
            if success {
                
                self.authenticateWithCredentialsInServer(username: username!, password: password!){
                    success, error in
                    
                    if success {
                        
                        self.getUdacityUser(userKey: self.userKey!){ success, udacityStudent, error in
                            
                            if success {
                                
                                self.udacityStudent = udacityStudent
                            
                                completionHandlerForAuth(true, nil)
                                
                            }else {
                            
                                displayError("Udacity User not Found", errorDetail: error!)
                            }
                        
                        }
                        
                    }else{
                        
                        displayError("Invalid Email or Password", errorDetail: error!)
                    }
                    
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
    

    
}
    
