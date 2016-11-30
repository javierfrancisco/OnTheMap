//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/27/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//



import UIKit



class StudentLocationTableViewController :  UITableViewController {



    
    var studentLocations = [ParseStudentLocation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in StudentLocationTableViewController viewDidLoad ")
        
        
        
        let pinButton   = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.plain , target: self, action: #selector(StudentLocationMapViewController.refreshMapView))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(StudentLocationMapViewController.refreshMapView))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(StudentLocationMapViewController.refreshMapView))
        
        
        self.navigationItem.leftBarButtonItem = logoutButton
        
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        
    }
    
    func showErrorAlert(_ error : String){
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("in -StudentLocationMapViewController- viewWillAppear")
        
        super.viewWillAppear(animated)
        
        studentLocations = (UIApplication.shared.delegate as! AppDelegate).studentLocations
        
        if(studentLocations.count == 0){
            
            loadStudentLocations()
            
        }else{
            
           // self.showStudentLocations(studentLocations: studentLocations)
        }
        
    }
    
    
    func loadStudentLocations() {
        
        
        ParseStudentLocationClient.sharedInstance().getStudentLocations(){ success, studentLocations , error in
            
            print("getStudentLocations call completed>")
            
            performUIUpdatesOnMain {
                if success {
                    print("success> students found: \(studentLocations?.count)")
                    
                    self.studentLocations = studentLocations!
                    
                    //self.showStudentLocations(studentLocations: studentLocations!)
                } else {
                    print("error>")
                    //self.showErrorAlert(errorString!)
                }
            }
            
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinTableCell")!
        let studentLocation = studentLocations[indexPath.row]
        
        // Set the studentLocation and image
        cell.textLabel?.text = studentLocation.firstName
        cell.imageView?.image = UIImage(named: "Pin")
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
      //  detailController.meme = self.memes[indexPath.row]
       // self.navigationController!.pushViewController(detailController, animated: true)
        
    }

    
}
