//
//  TabBarController.swift
//  OnTheMap
//
//  Created by zenkiu on 12/7/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//


import UIKit

class TabBarController: UITabBarController  {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in viewDidLoad ")
        
        let pinButton   = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.plain , target: self, action: #selector(TabBarController.createNewStudentLocation))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(TabBarController.refreshMapView))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(TabBarController.logout))
        
        
        self.navigationItem.leftBarButtonItem = logoutButton
        
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("in - viewWillAppear")
        
       loadStudentLocations()
        
    }
    
    func createNewStudentLocation(){
        
        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "NewStudentLocationViewController") as! NewStudentLocationViewController
        
        self.present(vc1, animated:true, completion: nil)
    }
    
    
    func refreshMapView(){
        
        print("in refreshMapView")
        
        loadStudentLocations()
    }
    
    func logout(){
        
        print("in logout")
        
        UdacityClient.sharedInstance().logout(sessionId: ""){
            success, errorString in
            
            performUIUpdatesOnMain {
                
                
                if success{
                    print("success>")
                    self.showLoginView()
                }else{
                    print("error>")
                    self.showErrorAlert("Error in Logout")
                }
                
                
            }
        }
        
    }
    
    func showLoginView(){
        
        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(vc1, animated:true, completion: nil)
    }
    
    func showErrorAlert(_ error : String){
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func loadStudentLocations() {
        
        
        ParseStudentLocationClient.sharedInstance().getStudentLocations(){ success, studentLocations , error in
            
            print("getStudentLocations call completed>")
            
            performUIUpdatesOnMain {
                if success {
                    print("success> students found: \(studentLocations?.count)")
                    
                    //self.studentLocations = studentLocations!
                    
                    (UIApplication.shared.delegate as! AppDelegate).studentLocations.append(contentsOf: studentLocations!)
                    
                    let v1 = self.viewControllers![0] as! StudentLocationMapViewController
                    v1.showStudentLocations(studentLocations: studentLocations!)
                    
                    
                    let v2 = self.viewControllers![1] as! StudentLocationTableViewController
                    
                    v2.studentLocations = studentLocations!
                    
                    if let pinsTable = v2.pinsTableView  {
                        
                      pinsTable.reloadData()
                    }
                   
                    
                    //self.showStudentLocations(studentLocations: studentLocations!)
                } else {
                    print("error>")
                    self.showErrorAlert(error!)
                }
            }
            
        }
        
    }

    
}
