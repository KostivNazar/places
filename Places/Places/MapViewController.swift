//
//  MapViewController.swift
//  Places
//
//  Created by Mac on 03.08.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var place: Places!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        mapView.delegate = self as MKMapViewDelegate
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(place.location, completionHandler: { placemarks, error in
            if error != nil {
                print("error")
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                annotation.title = self.place.name
                annotation.subtitle = self.place.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: place.image! as Data)!
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }

}
