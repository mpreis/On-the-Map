//
//  LinkViewController.swift
//  On the Map
//
//  Created by Mario Preishuber on 08/04/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit
import MapKit

class LinkViewController: UIViewController, MKMapViewDelegate {
    
    // Properties
    var appDelegate: AppDelegate!
    var mapString: String!
    var keyboardOnScreen = false
    
    private var coordinate:CLLocationCoordinate2D!
    
    // The map. See the setup in the Storyboard file.
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var submitButton: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        configureUI()
        
        subscribeToNotification(UIKeyboardWillShowNotification,
                                selector: #selector(LocationViewController.keyboardWillShow(_:)))
        subscribeToNotification(UIKeyboardWillHideNotification,
                                selector: #selector(LocationViewController.keyboardWillHide(_:)))
        subscribeToNotification(UIKeyboardDidShowNotification,
                                selector: #selector(LocationViewController.keyboardDidShow(_:)))
        subscribeToNotification(UIKeyboardDidHideNotification,
                                selector: #selector(LocationViewController.keyboardDidHide(_:)))
        
        CLGeocoder().geocodeAddressString(self.mapString, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            
            if let placemark = placemarks?.first {
                self.coordinate = placemark.location!.coordinate
                print("SUCCESS: Get coordinate of \(self.mapString) \(self.coordinate.longitude) / \(self.coordinate.latitude)")
                
                var annotations = [MKPointAnnotation]()
                let annotation = MKPointAnnotation()
                annotation.coordinate = self.coordinate
                annotation.title = "\(self.mapString)"
                annotations.append(annotation)
                self.mapView.addAnnotations(annotations)
                self.mapView.centerCoordinate = self.coordinate
            }
        })
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        if ((self.linkTextField.text?.isEmpty) != nil) {
            AppVariables.userData.prepareToUpdatePin(self.linkTextField.text!,
                                                     mapString: self.mapString,
                                                     latitude: self.coordinate.latitude,
                                                     longitude: self.coordinate.longitude)
            
            ParseClient.sharedInstance().setUserData(){ (success, errorString) in
                
                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarViewContorler") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        } else {
            self.infoTextLabel.text = "Enter link, please."
        }

    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else { pinView!.annotation = annotation }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }

}

extension LinkViewController: UITextFieldDelegate {
    
    // UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Show/Hide Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(linkTextField)
    }
    
}

// LinkViewController (Configure UI)
extension LinkViewController {
    
    private func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        configureTextField(linkTextField)
    }
    
    private func configureTextField(textField: UITextField) {
        let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .Always
        textField.backgroundColor = Constants.UI.GreyColor
        textField.textColor = Constants.UI.WhiteColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.tintColor = Constants.UI.WhiteColor
        textField.delegate = self
    }
    
}


// LinkViewController (Notifications)
extension LinkViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}