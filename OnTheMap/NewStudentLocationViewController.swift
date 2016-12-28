//
//  NewStudentLocationViewController.swift
//  OnTheMap
//
//  Created by zenkiu on 11/27/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit
import MapKit




class NewStudentLocationViewController :  UIViewController, UITextFieldDelegate, UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewLink: UIView!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let inputLocationText = "Enter your location here"
    let inputLinkText = "Enter a link to share here"
    
    let segueIdentifierForNextView = "onTheMapDetail"
    
    var studentLocations = [ParseStudentLocation]()
    
    
    var parseStudentLocation : ParseStudentLocation?
    var selectedPlacemark : CLPlacemark?
    
    
 
    func showLocationInMap(){
    
        
        let address = locationTextField.text
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
  
    
    @IBAction func findOnMap(_ sender: Any) {
   
    
        print("in findOnMap")
        
        showLinkView()
        showLocationInMap()

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("in NewStudentLocationViewController_viewDidLoad")
        
        prepareTextField(textField: locationTextField, defaultText: inputLocationText)
  
        
        prepareTextField(textField: linkTextField, defaultText: inputLinkText)
        
        
        self.subscribeToKeyboardNotifications()
        
        showLocationView()
        
    }
    
    func showLocationView(){
    
        viewLocation.isHidden = false
        viewLink.isHidden = true
    }
    
    func showLinkView(){
    
        viewLocation.isHidden = true
        viewLink.isHidden = false
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
   
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!
            ] as [String : Any]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text=defaultText
        
    }

    
    func subscribeToKeyboardNotifications() {
        
        print("IN-->subscribeToKeyboardNotifications")
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewStudentLocationViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewStudentLocationViewController.keyboardWillHide(notification:))   , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    var keyboardHeight : CGFloat = 0.0
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("IN-->keyboardWillShow")
        
        
        if(viewLocation.isHidden == true){
        
            return
        }
        
        
        keyboardHeight=getKeyboardHeight(notification: notification)
            
        view.frame.origin.y =  getKeyboardHeight(notification: notification) * -1
        
        
    }
    
 
    
    func keyboardWillHide(notification: NSNotification) {
        
        print("IN-->keyboardWillHide origin: \(self.view.frame.origin.y)")
 
        if(self.view.frame.origin.y == 0){
            return
        }
        
        self.view.frame.origin.y += keyboardHeight
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        //print("IN-->getKeyboardHeight")
        
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        //print("IN-->getKeyboardHeight2: \( keyboardSize.cgRectValue.height)")
        return keyboardSize.cgRectValue.height
    }
    
    
    @IBAction func performCancelAction(_ sender: Any) {
        
       
        cancelAction()
    }
    
    func cancelAction(){
         dismiss(animated: true,  completion: nil)
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

                    self.cancelAction()
                    
                } else {
                    print("error>")
                    self.showErrorAlert(error!)
                }
            }
            
        }
        
    }
    
    func showErrorAlert(_ error : String){
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        
        print(" in textFieldDidBeginEditing")
        
        if (textField.text == inputLocationText
            || textField.text == inputLinkText){
            
            textField.text = ""
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
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.MapString] = locationTextField.text as AnyObject?
        
        parseStudentDictionary[ParseStudentLocationClient.JSONResponseKeys.MediaURL] = linkTextField.text as AnyObject?
        
        
        
        
        
        parseStudentLocation = ParseStudentLocation(dictionary: parseStudentDictionary)
        
        
    }

        
        
}
