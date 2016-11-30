//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by zenkiu on 11/24/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

struct UdacityStudent {

    let firstName : String
    let lastName : String
    let key : String
    
    
    // construct a UdacityStudent from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        
        let user = dictionary[UdacityClient.JSONResponseKeys.User] as!  [String:AnyObject]
        
        firstName = user [UdacityClient.JSONResponseKeys.UserFirstName] as! String
        
        lastName = user [UdacityClient.JSONResponseKeys.UserLastName] as! String
        
        key = user [UdacityClient.JSONResponseKeys.UserKey] as! String
       
    }

}
