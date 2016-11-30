//
//  ParseStudentLocationConvenience.swift
//  OnTheMap
//
//  Created by zenkiu on 11/26/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import UIKit
import Foundation

// (Convenient Resource Methods)

extension ParseStudentLocationClient {


    
    func getStudentLocations(completionHandlerForStudent: @escaping (_ success : Bool, _ studentLocations : [ParseStudentLocation]?, _ errorString:  String? ) -> Void){
        
        
        getParseStudentLocationsFromUdacity(){
            success, studentLocations, error in
            
            
            if success {
            
                completionHandlerForStudent(true, studentLocations, nil)
                
            }else{
             
                completionHandlerForStudent(false, nil, "Student Locations Not Found")
            }
        
        }
        
        
        
    }
    



}
