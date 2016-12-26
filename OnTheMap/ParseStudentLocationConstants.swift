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
    
    struct RequestKey {
        
        static let ApplicationId = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
    
    }
    
    struct RequestValue {
    
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let Lastname = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    

}



