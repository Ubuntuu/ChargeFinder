//
//  Station.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 20/09/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

/********************************************************************************
 *  CLASS DESCRIPTIOM:
 *
 *  This class models a Station and extends the MKAnnotation type used in MapKit,
 *  it also uses the connector object and stores them in an array of connectors
 *  depending on the how many connectors the station has. This model is used when
 *  data is loaded from Firebase.
 */

import Foundation
import MapKit

class Station: NSObject, MKAnnotation {
    
    // Variables for creating a Station object.
    var title: String?
    var owner: String?
    var streetAddress: String?
    var zipcode: String?
    var city: String?
    var coordinate = CLLocationCoordinate2D()
    var connectors: [StationConnector]?
    
    // Initializer
    init(title: String?, owner: String, streetAddress: String, zipcode: String, city: String, coordinate: CLLocationCoordinate2D, connectors: [StationConnector]) {
        super.init()
        self.title = title
        self.owner = owner
        self.streetAddress = streetAddress
        self.zipcode = zipcode
        self.city = city
        self.coordinate = coordinate
        self.connectors = connectors
    }
    
    // Determines what type of data is displayed on the annotation on the map.
    var subtitle: String? {
        return streetAddress
    }
}
