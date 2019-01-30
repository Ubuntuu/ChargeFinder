//
//  EonChargeStations.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 06/09/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

/*  EonChargeStations is used for creating objects from json response from EonApi,
 *  it used for writing data to Firebase
 */

import Foundation

typealias EONStations = [EONStation]

// For creating EonStation objects
struct EONStation: Codable {
    let siteID: String
    let siteName: String
    let streetAddress: String
    let zipCode: Int
    let cityName: String
    let lat, lng: Double
    let connectors: [Connector]
    let status: Status
    let hasPoorCellReception: Bool?
    
    enum CodingKeys: String, CodingKey {
        case siteID = "siteId"
        case siteName, streetAddress, zipCode, cityName, lat, lng, connectors, status, hasPoorCellReception
    }
}

// For creating Connector object
struct Connector: Codable {
    let id: String
    let status: Status
}

// Enum for status on connectors.
enum Status: String, Codable {
    case available = "Available"
    case occupied = "Occupied"
    case unavailable = "Unavailable"
    case unknown = "Unknown"
}
