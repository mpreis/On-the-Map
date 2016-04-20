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
        
        ParseClient.sharedInstance().getStudentLocationList {
            (success, studLocs, errorString) in
            if success {
                print(":)")
                ParseClient.sharedInstance().studentLocationList = studLocs
                
                // Create an MKPointAnnotation for each student location.
                var annotations = [MKPointAnnotation]()
                
                for studLoc in ParseClient.sharedInstance().studentLocationList {
                    
                    let coordinate = CLLocationCoordinate2D(
                        latitude: CLLocationDegrees(studLoc.latitude),
                        longitude: CLLocationDegrees(studLoc.longitude))
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(studLoc.firstName) \(studLoc.lastName)"
                    annotation.subtitle = studLoc.mediaURL
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)

            } else {
                print(":(")
            }
        }
    }
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}
