//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/27/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//



import UIKit



class StudentLocationTableViewController :  UITableViewController {


    @IBOutlet var pinsTableView: UITableView!

    
    var studentLocations = [ParseStudentLocation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in StudentLocationTableViewController viewDidLoad ")
        
       
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("in -StudentLocationMapViewController- viewWillAppear")
        
        
        
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
