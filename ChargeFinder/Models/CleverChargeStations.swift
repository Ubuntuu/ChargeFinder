//
//  CleverChargeStations.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 06/09/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

/*
 *  This is used for creating objects from the Clever Api, and creating swift
 *  CleverStation Objects from the json response, Used for creating entries in
 *  Firebase.
 */
import Foundation

typealias CleverChargeStations = [CleverChargeStation]

/// Struct for Clever station object
struct CleverChargeStation: Codable {
    let latitude, longitude: Double
    let city: String
    let country: Country
    let houseNumber, locationType: String
    let minimapURL: String?
    let name, open24: String
    let pictureURL, postalCode: String?
    let publiclyAvailable: String
    let status: CleverStatus
    let streetName: String
    let connectors: [CleverConnector]
    let localizations: Localizations
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, city, country, houseNumber, locationType
        case minimapURL = "minimapUrl"
        case name, open24
        case pictureURL = "pictureUrl"
        case postalCode, publiclyAvailable, status, streetName, connectors, localizations
    }
}

/// Struct for Clever station Connector objects
struct CleverConnector: Codable {
    let available: Int
    let capacity: Capacity
    let connectorTypeName: ConnectorTypeName
    let number: String
}

/// Enum for power capacities
enum Capacity: String, Codable {
    case ac1122KW = "AC 11-22 kW"
    case ac43KW = "AC - 43 kW"
    case ac74KW = "AC - 7,4 kW"
    case dc50KW = "DC - 50 kW"
}

/// Enum for connector type names
enum ConnectorTypeName: String, Codable {
    case ac43Type2 = "AC43 Type 2"
    case ccsType2 = "CCS Type 2"
    case chAdeMO = "CHAdeMO"
    case iecType1 = "IEC Type 1"
    case iecType2 = "IEC Type 2"
}

/// Enum for Country names
enum Country: String, Codable {
    case danmark = "Danmark"
    case sverige = "Sverige"
}

/// Struct for Localization
struct Localizations: Codable {
    let daDk, svSE: DaDk
    
    enum CodingKeys: String, CodingKey {
        case daDk = "DA-DK"
        case svSE = "SV-SE"
    }
}

/// Struct for danish localization
struct DaDk: Codable {
    let descriptionText, openingHoursText: String?
    let paymentButtonText: PaymentButtonText?
    let paymentMethodText: PaymentMethodText?
    let phoneName: PhoneName?
    let phoneNumber: String?
    let descripber: String?
}

/// Enum for payment button (unused by the app)
enum PaymentButtonText: String, Codable {
    case köp = "Köp"
    case køb = "Køb"
}

/// Enum for payment method (unused by the app)
enum PaymentMethodText: String, Codable {
    case cleverAbonnement = "CLEVER abonnement"
    case cleverAbonnementSMS = "CLEVER Abonnement & SMS"
    case empty = "-"
    case gratis = "Gratis"
    case kostnadsfrittFörHotellgäster = "Kostnadsfritt för hotellgäster"
    case paymentMethodTextCLEVERAbonnement = "CLEVER Abonnement"
    case the120SEKDagparkering245SEKNattparkering = "120 SEK Dagparkering, 245 SEK nattparkering"
}

/// Enum for support phone name (unused by the app)
enum PhoneName: String, Codable {
    case empty = "-"
    case kundeservice = "Kundeservice"
    case kundservice = "Kundservice"
    case kundtjänst = "Kundtjänst"
}

/// Enum for setting the Setting the Station connectors status.
enum CleverStatus: String, Codable {
    case availableAC = "AvailableAC"
    case availableDC = "AvailableDC"
    case availableDual = "AvailableDual"
    case availableWithUnAvailableDual = "AvailableWithUnAvailableDual"
    case unAvailableAC = "UnAvailableAC"
    case unAvailableDC = "UnAvailableDC"
    case unknown = "Unknown"
}
