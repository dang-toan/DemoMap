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
    var annotationArray: [CustomAnnotation] = [CustomAnnotation]()
    
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
        
        //Add all annotation on mapView
        self.addAnnotationsOnMapView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Get last location
        let currentLocation = locations.last
        let region = MKCoordinateRegionMake((currentLocation?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //Display current location on map
        mapView.setRegion(region, animated: true)
        
        //Stop auto focus current location
        locationManager.stopUpdatingLocation()
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
    
    func addAnnotationsOnMapView(){
        //get current location
        let currentLocation = locationManager.location?.coordinate
        
        let myFakeLocation = CLLocationCoordinate2D(latitude: 10.793235, longitude: 106.719856)
        let destinationLocation = CLLocationCoordinate2D(latitude: 10.803255, longitude: 106.837952)
        
        var sourceAnnotation: CustomAnnotation
        
        if(currentLocation != nil){
            //create annotation
            sourceAnnotation = CustomAnnotation(title: "Pascalia Asia", subtitle: "Nguyen Huu Canh, Binh Thanh, HCM", coordinate: currentLocation!, image: UIImage(named: "hotel")!)
        } else {
            sourceAnnotation = CustomAnnotation(title: "Pascalia Asia", subtitle: "Nguyen Huu Canh, Binh Thanh, HCM", coordinate: myFakeLocation, image: UIImage(named: "hotel")!)
        }
        
        
        let destinationAnnotation = CustomAnnotation(title: "The BCR", subtitle: "191 Tam Đa, W.Truong Thanh, D9. Hotline: 094 6664 616, 0903 038 100", coordinate: destinationLocation, image: UIImage(named: "hotel")!)
        
        self.annotationArray.append(sourceAnnotation)
        self.annotationArray.append(destinationAnnotation)
        
        //add annotation into mapView
        mapView.addAnnotations(annotationArray)
        
        //Draw line
        drawLineTwoLocations(sourceLocation: myFakeLocation, destinationLocation: destinationLocation)
    }
    
    func drawLineTwoLocations(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D){
        
        //Step 1
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        //Step 2
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        //Step 3
        let directRequest = MKDirectionsRequest()
        directRequest.source = sourceMapItem
        directRequest.destination = destinationMapItem
        directRequest.transportType = .walking
        
        //Step 4
        let directions = MKDirections(request: directRequest)
        directions.calculate { (response, error) in
            if error == nil {
                //Sometimes there is not route between 2 point in map
                if let route = response?.routes.first {
                    
                    self.mapView.add(route.polyline, level: .aboveRoads)
                    
                    //Auto zoom map after search
                    let rect = route.polyline.boundingMapRect
                    self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsetsMake(40, 40, 20, 20), animated: true)
                }
            } else {
                print("There is a error: ")
                print(error?.localizedDescription)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rederer = MKPolylineRenderer(overlay: overlay)
        
        rederer.strokeColor = UIColor.blue
        rederer.lineWidth = 2.0
        
        return rederer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

