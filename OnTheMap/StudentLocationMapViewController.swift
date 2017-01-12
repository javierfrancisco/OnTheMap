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
        
      
        
        
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("in -StudentLocationMapViewController- viewWillAppear")
        
        super.viewWillAppear(animated)
        
       // studentLocations = (UIApplication.shared.delegate as! AppDelegate).studentLocations
        
        studentLocations = ParseStudentLocationClient.sharedInstance().studentLocations
       
        
        print("studentLocations count::: \(studentLocations.count)")
        if(studentLocations.count == 0){
            
            //loadStudentLocations()
        
        }else{
        
            self.showStudentLocations(studentLocations: studentLocations)
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
            
            if let lat = studentLocation.latitude, let long =  studentLocation.longitude {
        
                
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                
                if let first = studentLocation.firstName, let last = studentLocation.lastName, let mediaURL = studentLocation.mediaURL{
                
                
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
            }
            
            
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
