//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by zenkiu on 11/20/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

extension UdacityClient{

    
    struct Constants {
        

        // URLs
        //Sample URL: https://www.udacity.com/api/session
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL = "https://www.udacity.com/api/session"
        //static let AccountURL = "https://www.themoviedb.org/account/"
    }
    
    struct Methods {
    
        static let SessionNew = "/session"
        
        static let User = "/users"
    }
    
    struct ParametersKeys {
        static let Username = "username"
        static let Password = "password"

    }
    
    struct JSONResponseKeys {
        
        //Session
        static let Session = "session"
        static let SessionId = "id"
        
        //Account
        static let Account = "account"
        static let AccountKey = "key"
        
        //User
        static let User = "user"
        static let UserLastName = "last_name"
        static let UserFirstName = "first_name"
        static let UserKey = "key"
    }
}
