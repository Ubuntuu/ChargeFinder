//
//  SuperchargeChargeStations.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 06/09/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

import Foundation

typealias SuperchargeStations = [SuperchargeStation]

/// Struct for creating Supercharger stations, from json objects.
struct SuperchargeStation: Codable {
    let id: Int
    let locationID: String?
    let name: String
    let status: String
    let address: Address
    let gps: Gps
    let dateOpened: String?
    let stallCount: Int
    let counted: Bool
    let elevationMeters, powerKilowatt: Int
    let solarCanopy, battery: Bool
    let statusDays: Int
    let urlDiscuss: Bool
    let hours: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case locationID = "locationId"
        case name, status, address, gps, dateOpened, stallCount, counted, elevationMeters, powerKilowatt, solarCanopy, battery, statusDays, urlDiscuss, hours
    }
}

/// Struct for address object in supercharger station object.
struct Address: Codable {
    let street, city: String
    let state, zip: String?
    let countryID: Int
    let country: SuperchargeCountry
    let regionID: Int
    let region: Region
    
    enum CodingKeys: String, CodingKey {
        case street, city, state, zip
        case countryID = "countryId"
        case country
        case regionID = "regionId"
        case region
    }
}

/// Enum for country.
enum SuperchargeCountry: String, Codable {
    case australia = "Australia"
    case austria = "Austria"
    case belgium = "Belgium"
    case canada = "Canada"
    case china = "China"
    case croatia = "Croatia"
    case czechRepublic = "Czech Republic"
    case denmark = "Denmark"
    case finland = "Finland"
    case france = "France"
    case germany = "Germany"
    case hungary = "Hungary"
    case ireland = "Ireland"
    case italy = "Italy"
    case japan = "Japan"
    case jordan = "Jordan"
    case liechtenstein = "Liechtenstein"
    case luxembourg = "Luxembourg"
    case mexico = "Mexico"
    case netherlands = "Netherlands"
    case newZealand = "New Zealand"
    case norway = "Norway"
    case poland = "Poland"
    case portugal = "Portugal"
    case russia = "Russia"
    case slovakia = "Slovakia"
    case slovenia = "Slovenia"
    case southKorea = "South Korea"
    case spain = "Spain"
    case sweden = "Sweden"
    case switzerland = "Switzerland"
    case taiwan = "Taiwan"
    case unitedArabEmirates = "United Arab Emirates"
    case unitedKingdom = "United Kingdom"
    case usa = "USA"
}

/// Enum for region
enum Region: String, Codable {
    case asiaPacific = "Asia Pacific"
    case europe = "Europe"
    case northAmerica = "North America"
}

/// GPS object, unused by the app.
struct Gps: Codable {
    let latitude, longitude: Double
}

/// Enum for status.
enum SuperchargeStatus: String, Codable {
    case closed = "CLOSED"
    case construction = "CONSTRUCTION"
    case permit = "PERMIT"
    case statusOPEN = "OPEN"
}
