//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by zenkiu on 11/20/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation


class UdacityClient : NSObject{
    
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    
    // udacity user key
    var userKey: String? = nil
    
    var udacityStudent : UdacityStudent? = nil
    
    
    func getUdacityUser(userKey : String, completionHandlerForUser: @escaping (_ success: Bool, _ udacityStudent : UdacityStudent?,  _ errorString: String?) -> Void){
        
        let method = UdacityClient.Methods.User.appending("/").appending(userKey)
        
        let _ = taskForGETMethod(method, parameters: [String:AnyObject]()){ (results, error) in
            
            func displayError(_ error: String){
                
                print(error)
                completionHandlerForUser(false, nil, "Udacity User Not Found")
            }
            
            if error != nil {
                
                displayError("Response returned an error")
            }
            
            
            guard let results = results else {
                
                displayError("Cannot find 'results' in Response")
                return
            }
            
            guard let user = results[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject], let _ = user[UdacityClient.JSONResponseKeys.UserFirstName] as! String?, let _ = user[UdacityClient.JSONResponseKeys.UserLastName] as! String? else{
                
                displayError("Cannot find mandatory key from 'user'")
                return
            }
           
            let udacityStudent : UdacityStudent = UdacityStudent(dictionary: results as! [String : AnyObject])
            
            print("User found--> \(udacityStudent.firstName)")
            
            
            completionHandlerForUser(true, udacityStudent, nil)
            
            
        }
    
    
    }
    
    func logoutFromUdacity(sessionId : String, completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        let method = UdacityClient.Methods.SessionNew
        
        let _ = taskForDeleteMethod(method, parameters: [String:AnyObject]()){ (results, error) in
            
            func displayError(_ error: String){
                
                print(error)
                completionHandlerForLogout(false, "Error in Logout")
            }
            
            if error != nil {
                
                displayError("Response returned an error")
            }
            
            
            guard let results = results else {
                
                displayError("Cannot find 'results' in Response")
                return
            }
            
            
            
            
            completionHandlerForLogout(true, nil)
            
            
        }
        
        
    }

    
    
    func authenticateWithCredentialsInServer(username : String, password : String , completionHandlerForAuth: @escaping (_ success: Bool,  _ errorString: String?) -> Void){
    
        
        //Getting ready to call the server
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        print("JsonBody--> \(jsonBody)")
        
        let _ = taskForPOSTMethod(UdacityClient.Methods.SessionNew, parameters: [String:AnyObject]() , jsonBody: jsonBody){ (results, error) in
            
            func displayError(_ error: String){
                
                print(error)
                completionHandlerForAuth(false, "Login Failed")
            }
            
            if error != nil {
                
                displayError("Response returned an error")
            }
            
            
            guard let results = results else {
                
                displayError("Cannot find 'results' in Response")
                return
            }
            
            guard let session = results[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject], let sessionId = session[UdacityClient.JSONResponseKeys.SessionId] as! String? else{
                
                displayError("Cannot find key 'sessionId'")
                return
            }
            
            print("session found: \(sessionId)")
            self.sessionID = sessionId;
            
            //get Udacity User Key
            guard let account = results[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject], let key = account[UdacityClient.JSONResponseKeys.AccountKey] as! String? else{
                
                displayError("Cannot find key 'key' in \(UdacityClient.JSONResponseKeys.Account)")
                return
            }
            
            print("key found \(key)")
            self.userKey = key;

            
            completionHandlerForAuth(true, nil)
            
            
        }
    }
    
    
  
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
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
            
            let range = Range(uncheckedBounds: (5, data.count ))
            let newData = data.subdata(in: range) /* subset response data! */
            
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }

    
    
    // create a URL from parameters
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        
        
        if parameters.count > 0 {
            
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
            
        }

        
        return components.url!
    }
    
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
      
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        
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

    
    func taskForDeleteMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            
            //print("cookie: \(cookie.name) -value- \(cookie.value)")
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDelete(nil, NSError(domain: "taskForDeleteMethod", code: 1, userInfo: userInfo))
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
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDelete)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    

    
    
    //Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    

}
