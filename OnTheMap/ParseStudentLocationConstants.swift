//
//  ParseStudentLocationClient.swift
//  OnTheMap
//
//  Created by zenkiu on 11/26/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//


extension ParseStudentLocationClient {

    
    struct Constants {
        
        
        // URLs
        //Sample URL: https://parse.udacity.com/parse/classes/StudentLocation
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"

    }
    
    struct Methods {
        
        static let StudentLocation = "/StudentLocation"
        
        static let User = "/users"
    }
    
    
    
    struct ParametersKeys {
        static let Username = "username"
        static let Password = "password"
        
    }
    
    struct JSONResponseKeys {
        
        
        //Results
        static let Results = "results"
        
        
        //StudentLocation
        static let CreateAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdateAd = "updatedAt"
    }


}



