//
//  FirstViewController.swift
//  On the Map
//
//  Created by Mario Preishuber on 29/03/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: NavBarButtonController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file.
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance().getUserLocationList {
            (success, userDataList, errorString) in
            if success {
                ParseClient.sharedInstance().userDataList = userDataList
                
                // Create an MKPointAnnotation for each student location.
                var annotations = [MKPointAnnotation]()
                for userData in ParseClient.sharedInstance().userDataList {
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: CLLocationDegrees(userData.getLatitude()),
                        longitude: CLLocationDegrees(userData.getLongitude()))
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(userData.getFirstName()) \(userData.getLastName())"
                    annotation.subtitle = userData.getMediaURL()
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            }
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
