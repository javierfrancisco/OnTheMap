//
//  StudentData.swift
//  OnTheMap
//
//  Created by zenkiu on 1/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation


class StudentData {
    
    var studentData: [ParseStudentLocation]?
    
    init() {
        
    }
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
    
}
