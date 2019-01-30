//
//  Connector.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 20/09/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

/********************************************************************************
 *  CLASS DESCRIPTIOM:
 *
 *  This class models connectors used for creating connector object, which is an
 *  object use for Stations and its annotations in MapKit.
 */

import Foundation

class StationConnector: NSObject {
    
    // Variables used for a connector
    var connectorID: String?
    var status: String?
    var type2: Bool?
    var ccs: Bool?
    var chademo: Bool?
   
    // Initializer for connector.
    init(connectorID: String, status: String, type2: Bool, ccs: Bool, chademo: Bool) {
        super.init()
        self.connectorID = connectorID
        self.status = status
        self.type2 = type2
        self.ccs = ccs
        self.chademo = chademo
    }
}
