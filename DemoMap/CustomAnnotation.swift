//
//  CustomAnnotation.swift
//  DemoMap
//
//  Created by Dang Anh Toan on 10/9/16.
//  Copyright © 2016 dangtoan.pascalia. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, image: UIImage) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
        
        super.init()
    }
}
