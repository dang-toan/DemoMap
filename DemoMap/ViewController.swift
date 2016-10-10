//
//  ViewController.swift
//  DemoMap
//
//  Created by Dang Anh Toan on 10/3/16.
//  Copyright © 2016 dangtoan.pascalia. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        //How long update location?
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        //Show user's location
        mapView.showsUserLocation = true;
        
        //get current location
        let currentLocation = locationManager.location?.coordinate
        
        var latitude: Double = 10.793235
        var longitude: Double = 106.719856
        
        if(currentLocation != nil){
            //create annotation
            latitude = (currentLocation?.latitude)!
            longitude = (currentLocation?.longitude)!
        }
        
        let annotation = CustomAnnotation(title: "Pascalia Asia", subtitle: "Nguyen Huu Canh, Binh Thanh, HCM", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), image: UIImage(named: "hotel")!)
        
        //add annotation into mapView
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Get last location
        let currentLocation = locations.last
        let region = MKCoordinateRegionMake((currentLocation?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //Display current location on map
        mapView.setRegion(region, animated: true)
        
        //Stop auto focus current location
        locationManager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let myAnnotation = annotation as? CustomAnnotation{
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPinAnnotationView")
            if pinView == nil {
                pinView = MKAnnotationView(annotation: myAnnotation, reuseIdentifier: "CustomPinAnnotationView")
                pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                pinView?.canShowCallout = true
                pinView?.calloutOffset = CGPoint(x: 0, y: 4)
                pinView?.contentMode = .scaleAspectFill
            } else {
                pinView?.annotation = annotation
            }
            pinView?.image = myAnnotation.image
            
            return pinView
        }
        
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

