//
//  ViewController.swift
//  DemoMap
//
//  Created by Dang Anh Toan on 10/3/16.
//  Copyright © 2016 dangtoan.pascalia. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        //How long update location?
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Show user's location
        mapView.showsUserLocation = true;
        
        //get current location
        let currentLocation = locationManager.location?.coordinate
        
        //create annotation
        let annotation = CustomAnnotation(title: "Pascalia Asia", subtitle: "180/54 Nguyen Huu Canh, Ward 22, Binh Thanh District, Ho Chi Minh City", coordinate: CLLocationCoordinate2D(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!))
        
        //add annotation into mapView
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Get last location
        let currentLocation = locations.last
        let region = MKCoordinateRegionMake((currentLocation?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //Display current location on map
        mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

