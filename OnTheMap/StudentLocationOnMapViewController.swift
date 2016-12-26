//
//  StudentLocationOnMapViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/27/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class StudentLocationOnMapViewController :  UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mediaUrlTextField: UITextField!
    @IBOutlet weak var submitButton: MapBorderedButton!
    
    var locationMapStringValue: String?
    
    var parseStudentLocation : ParseStudentLocation?
    
    var selectedPlacemark : CLPlacemark?

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("in StudentLocationOnMapViewController viewDidLoad ")
        
        let address = locationMapStringValue
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!){ placemarks, error in
            
            if error != nil {
            
                print(":::CLGeocoder sent an error")
            }
            
            guard let placemark = placemarks?[0] else {
            
                print(":::CLGeocoder cannot find placemark")
                return
            }
            
            self.selectedPlacemark = placemark
        
            self.mapView.addAnnotation(MKPlacemark(placemark: placemark))

            
        }
        
        
        
    }
    
    func createStudentLocationInView(){
        
        let udacityStudent = UdacityClient.sharedInstance().udacityStudent
        
        var parseStudentDictionary = [String:AnyObject]()
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.FirstName] = udacityStudent?.firstName as AnyObject?
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.LastName] = udacityStudent?.lastName as AnyObject?
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.UniqueKey] = udacityStudent?.key as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.Latitude] = self.selectedPlacemark?.location?.coordinate.latitude as AnyObject?
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.Longitude] = self.selectedPlacemark?.location?.coordinate.longitude as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.MapString] = locationMapStringValue as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.MediaURL] = mediaUrlTextField.text as AnyObject?
        

        
        
        
        parseStudentLocation = ParseStudentLocation(dictionary: parseStudentDictionary)
    
    
    }
    
    
    @IBAction func performCancelAction(_ sender: Any) {
        
        
       
        dismiss(animated: true, completion:  nil)
        //performSegue(withIdentifier: "unwind", sender: nil)
        
        
    }
    @IBAction func submitAction(_ sender: Any) {
        
        print("in submitAction ")
        
       // parseStudentLocation?.latitude
        
        
        createStudentLocationInView()
        
        
        ParseStudentLocationClient.sharedInstance().saveParseStudentLocation(parseStudentLocation: parseStudentLocation!){ success, error in
            
            print("saveParseStudentLocation call completed>")
            
            performUIUpdatesOnMain {
                if success {
                    print("success> saveParseStudentLocation: ")
                    
                    self.goToInitialView()
                    
                } else {
                    print("error>")
                    //self.showErrorAlert(errorString!)
                }
            }
            
        }
    }
    
    func goToInitialView(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StudentLocationMapViewController") as! StudentLocationMapViewController
        //vc.userChoice = getUserShape(sender)
        
        present(vc, animated: true, completion: nil)
    
    }
    
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {
    
        print("in myUnwindAction ")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
    
