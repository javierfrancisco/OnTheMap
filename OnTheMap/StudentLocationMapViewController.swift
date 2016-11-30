//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/24/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import UIKit
import MapKit


class StudentLocationMapViewController : UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var studentLocations = [ParseStudentLocation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in viewDidLoad ")
        
        let pinButton   = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.plain , target: self, action: #selector(StudentLocationMapViewController.createNewStudentLocation))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(StudentLocationMapViewController.refreshMapView))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(StudentLocationMapViewController.logout))
      

        self.navigationItem.leftBarButtonItem = logoutButton
        
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("in -StudentLocationMapViewController- viewWillAppear")
        
        super.viewWillAppear(animated)
        
        studentLocations = (UIApplication.shared.delegate as! AppDelegate).studentLocations
        
        print("studentLocations count::: \(studentLocations.count)")
        if(studentLocations.count == 0){
            
            loadStudentLocations()
        
        }else{
        
            self.showStudentLocations(studentLocations: studentLocations)
        }
        
    }
    
    
    func refreshMapView(){
        
        print("in refreshMapView")
        
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
    
    func showErrorAlert(_ error : String){
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func createNewStudentLocation(){
    
        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "NewStudentLocationViewController") as! NewStudentLocationViewController
        
        self.present(vc1, animated:true, completion: nil)
    }
    
    func showLoginView(){
        
        let vc1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(vc1, animated:true, completion: nil)
    }
    
    
    
    
    
    func loadStudentLocations() {
        
        
        ParseStudentLocationClient.sharedInstance().getStudentLocations(){ success, studentLocations , error in
            
              print("getStudentLocations call completed>")
            
                performUIUpdatesOnMain {
                    if success {
                        print("success> students found: \(studentLocations?.count)")
                        
                        //self.studentLocations = studentLocations!
                        
                        (UIApplication.shared.delegate as! AppDelegate).studentLocations.append(contentsOf: studentLocations!)
                        
                        self.showStudentLocations(studentLocations: studentLocations!)
                    } else {
                        print("error>")
                        //self.showErrorAlert(errorString!)
                    }
                }
            
            }
    
    }
    
    func showStudentLocations(studentLocations : [ParseStudentLocation]){
    
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for studentLocation in studentLocations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    
    }
    
    
    // MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
}
