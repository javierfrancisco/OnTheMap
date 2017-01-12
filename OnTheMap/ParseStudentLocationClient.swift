//
//  ParseStudentLocationConstants.swift
//  OnTheMap
//
//  Created by zenkiu on 11/26/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation


class ParseStudentLocationClient : NSObject {


    // shared session
    var session = URLSession.shared
    
    var studentLocations = [ParseStudentLocation]()

    
    
    func getParseStudentLocationsFromUdacity(completionHandlerForParseStudent: @escaping (_ success: Bool, _ parseStudentLocations : [ParseStudentLocation]?,  _ errorString: String?) -> Void){
        
        let method = ParseStudentLocationClient.Methods.StudentLocation
        
        let parameters = [ParseStudentLocationClient.ParametersKeys.Limit : ParseStudentLocationClient.ParametersValues.Limit,
                          ParseStudentLocationClient.ParametersKeys.Order : ParseStudentLocationClient.ParametersValues.Order]
        
        
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]){ (results, error) in
            
            func displayError(_ error: String){
                
                print(error)
                completionHandlerForParseStudent(false, nil, "Udacity StudentLocation Not Found")
            }
            
            if error != nil {
                
                displayError("Response returned an error")
            }
            
            
            guard let results = results else {
                
                displayError("Cannot find 'results' in Response")
                return
            }
            
            guard let studentsLocatiionsList = results[ParseStudentLocationClient.JSONResponseKeys.Results] as? [[String:AnyObject]] else{
                
                displayError("Cannot find mandatory key 'results'")
                return
            }
            
            
            var parseStudentLocationsArr = [ParseStudentLocation]()

            for studentLocationDictionary in studentsLocatiionsList {
            
            
                let studentLocation : ParseStudentLocation = ParseStudentLocation(dictionary: studentLocationDictionary )

                parseStudentLocationsArr.append(studentLocation)
            }
            
            
            completionHandlerForParseStudent(true, parseStudentLocationsArr, nil)
            
            
        }

    }
    
    
    func saveParseStudentLocationService( parseStudentLocation : ParseStudentLocation, completionHandlerForStudentLocation: @escaping (_ succes : Bool, _ errorString: String?) -> Void ) {
        
        
        //Sample student location:
       // "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
        
        //Getting ready to call the server
        let jsonBody = "{\"\(ParseStudentLocationClient.JSONBodyKeys.UniqueKey)\": \"\(parseStudentLocation.uniqueKey!)\", \"\(ParseStudentLocationClient.JSONBodyKeys.FirstName)\": \"\(parseStudentLocation.firstName!)\", \"\(ParseStudentLocationClient.JSONBodyKeys.Lastname)\": \"\(parseStudentLocation.lastName!)\",\"\(ParseStudentLocationClient.JSONBodyKeys.MapString)\": \"\(parseStudentLocation.mapString!)\", \"\(ParseStudentLocationClient.JSONBodyKeys.MediaURL)\": \"\(parseStudentLocation.mediaURL!)\",\"\(ParseStudentLocationClient.JSONBodyKeys.Latitude)\": \(parseStudentLocation.latitude!), \"\(ParseStudentLocationClient.JSONBodyKeys.Longitude)\": \(parseStudentLocation.longitude!)}"
        
        
        print("JsonBody--> \(jsonBody)")
        
        let _ = taskForPOSTMethod(UdacityClient.Methods.StudentLocation, parameters: [String:AnyObject]() , jsonBody: jsonBody){ (results, error) in
            
            func displayError(_ error: String){
                
                print(error)
                completionHandlerForStudentLocation(false, "Error while creating new Student Location")
            }
            
            if error != nil {
                
                displayError("Response returned an error")
            }
            
            
            guard let results = results as? [String:AnyObject] else {
                
                displayError("Cannot find 'results' in Response")
                return
            }
            
            for (key, value) in results {
            
                print("key \(key) and value: \(value)")
            }
            
            
            
            completionHandlerForStudentLocation(true, nil)
            
            
        }
        
        
    }
    
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseStudentLocationURLFromParameters(parameters, withPathExtension: method))
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseStudentLocationURLFromParameters(parameters, withPathExtension: method)) 
        
        
        request.addValue(ParseStudentLocationClient.RequestValue.ApplicationId, forHTTPHeaderField: ParseStudentLocationClient.RequestKey.ApplicationId)
        request.addValue(ParseStudentLocationClient.RequestValue.ApiKey, forHTTPHeaderField: ParseStudentLocationClient.RequestKey.ApiKey)
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        print("Request--> \(request.url)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx! \((response as? HTTPURLResponse)?.statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    
    
    // create a URL from parameters
    private func parseStudentLocationURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        
        
        components.scheme = ParseStudentLocationClient.Constants.ApiScheme
        components.host = ParseStudentLocationClient.Constants.ApiHost
        components.path = ParseStudentLocationClient.Constants.ApiPath + (withPathExtension ?? "")
        
        
        if parameters.count > 0 {
            
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
            
        }
        
        print("StudentLocationURL---> \(components.url!)")
        
        return components.url!
    }

    
    
    //Shared Instance
    
    class func sharedInstance() -> ParseStudentLocationClient {
        struct Singleton {
            static var sharedInstance = ParseStudentLocationClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
