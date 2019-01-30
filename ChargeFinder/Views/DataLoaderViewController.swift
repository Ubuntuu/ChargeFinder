//
//  DataLoaderViewController.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 17/09/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class DataLoaderViewController: UIViewController {

    var dispatchGroupFirebase = DispatchGroup()
    var stationData: [Station] = []
    var dataLoaded = false
    
    lazy var splashLogoView: UIImageView = {
        let image = UIImage(named: "splash_icon")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var activityIndicator: UIView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        let activityIndicatorView = UIView()
        activityIndicatorView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    lazy var cfLogoView: UIImageView = {
        let image = UIImage(named: "chargefinder_logotype")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Adds UI Elements to the view.
    func loadViewUIAssets() {
        view.addSubview(splashLogoView)
        view.addSubview(activityIndicator)
        view.addSubview(cfLogoView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
                splashLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                splashLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
                cfLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                cfLogoView.heightAnchor.constraint(equalToConstant: 32),
                cfLogoView.widthAnchor.constraint(equalToConstant: 168),
                cfLogoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewUIAssets()
        tasks()
    }
    
    // Function for fetching data and awaiting until data has been return before continuing.
    func tasks() {
        //self.fetchDataFromEonAPI()
        //self.fetchDataFromCleverAPI()
        //self.fetchDataFromSuperchargeAPI()
        self.fetchStationsFromFirebase()
        dispatchGroupFirebase.notify(queue: .main) {
            self.performSegue(withIdentifier: "dataSegue", sender: self)
        }
    }
    
    // Function for praparing data for the segue, and setting up what data to send with it.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dataSegue") {
            let destinationViewController = segue.destination as! MainViewController
            destinationViewController.dViewController = self
            destinationViewController.data = stationData
        }
    }
    
    /// Function for getting data from Clever API and writes that data to Firebase
    func fetchDataFromCleverAPI() {
        dispatchGroupFirebase.enter()
        // Variables necessary for writing data to Firebase.
        var stationID = 0
        var cID = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // URL path for getting data from the api.
        guard let cleverUrl = URL(string: "https://clever.dk/umbraco/Api/ChargepointApi/GetChargepointData?operatorId=1") else { return }
        
        URLSession.shared.dataTask(with: cleverUrl) {
            (data, reponse, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let cleverData = try decoder.decode([CleverChargeStation].self, from: data)
                
                // Creates a station for each entry returnned from the api.
                for entry in cleverData {
                    // Station id for firebase
                    let id = String("cle-\(stationID)")
                    
                    // Creates a new Station with given data.
                    let station = [
                        "name": entry.name,
                        "owner": "Clever",
                        "latitude": entry.latitude,
                        "longitude": entry.longitude,
                        "streetAddress": "\(entry.streetName) \(entry.houseNumber)",
                        "zipcode": entry.postalCode as Any,
                        "city": entry.city
                    ] as [String : Any]
                    
                    // Writes the Station to Firebase.
                    ref.child("stations").child(id).setValue(station)
                    
                    for connector in entry.connectors {
                        // connector ID for Firebase.
                        let connectorID = "con-\(cID)"
                        // Number of connectors from the api.
                        var numberOfConnectors = Int(connector.number)!
                        // Number of Availabel connectors from the api.
                        var numberOfAvailable = Int(connector.available)
                        // Status will be set as either "Available" or "Occupied" depending on the number of available.
                        var status: String
                        // Sets Boolean values, for wether a connector type is available.
                        var type2IsAvailable = false
                        var ccsIsAvailable = false
                        var chademoIsAvailable = false
                        
                        // Creates a connector depending on the number of connectors given from the api.
                        while numberOfConnectors >= 1 {
                            
                            // Checks checks wether a connector is available or occupied.
                            if numberOfAvailable >= 1 {
                                status = "Available"
                                numberOfAvailable -= 1
                            } else {
                                status = "Occupied"
                            }
                            
                            // Checks what connector types are available sets a boolean value accordingly.
                            if connector.connectorTypeName.rawValue == "IEC Type 2" || connector.connectorTypeName.rawValue == "AC43 Type 2" {
                                type2IsAvailable = true
                            } else if connector.connectorTypeName.rawValue == "CCS Type 2" {
                                ccsIsAvailable = true
                            } else if connector.connectorTypeName.rawValue == "CHAdeMO" {
                                chademoIsAvailable = true
                            } else {
                                type2IsAvailable = false
                                ccsIsAvailable = false
                                chademoIsAvailable = false
                            }
                            
                            // Creates a new connector with given data.
                            let connector = [
                                "status": status,
                                "type 2": type2IsAvailable,
                                "ccs": ccsIsAvailable,
                                "chademo": chademoIsAvailable
                            ] as [String : Any]
                            
                            // Writes the connector to Firebase.
                            ref.child("stations/\(id)/connectors/").child(connectorID).setValue(connector)
                            
                            // decrements the number of connectors left when a connector was created
                            numberOfConnectors -= 1
                            // Sets a new connector id when a connector was created.
                            cID += 1
                        }
                    }
                    // Sets a new id number when a station was created.
                    stationID += 1
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
        dispatchGroupFirebase.leave()
    }
    
    /// Function for getting data from EON API and writes that data to Firebase
    func fetchDataFromEonAPI() {
        dispatchGroupFirebase.enter()
        // Variables needed for Firebase ID's
        var entryID = 0
        var cID = 0
        
        // Reference for Firebase.
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // URL for fetching data from eon api.
        guard let eonUrl = URL(string: "https://opladdinelbil.dk/data.json") else { return }
        
        URLSession.shared.dataTask(with: eonUrl) {
            (data, reponse, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let eonData = try decoder.decode([EONStation].self, from: data)
        
                // Will create a Station from each data entry returned from the api.
                for entry in eonData {
                    
                    // Variable for a station id in Firebase.
                    let id = String("eon-\(entryID)")
                    
                    // New station object for firebase.
                    let station = [
                        "name": entry.siteName,
                        "owner": "e.on",
                        "latitude": entry.lat,
                        "longitude": entry.lng,
                        "streetAddress": entry.streetAddress,
                        "zipcode": entry.zipCode,
                        "city": entry.cityName
                    ] as [String : Any]
                    
                    // Wrtie station data to Firebase.
                    ref.child("stations").child(id).setValue(station)
                    
                    // Will create a connector from each connector entry in a station.
                    for connector in entry.connectors {
                        
                        // Variable for connector id in Firebase.
                        let connectorID = "connector-\(cID)"
                        
                        // Variable for wether a connector is available, occupied or otherwise unavailable.
                        let status = String(Substring(connector.status.rawValue))
                        
                        // New Connector object for Firebase.
                        let connector = [
                            "status": status,
                            "type 2": true,
                            "ccs": false,
                            "chademo": false
                        ] as [String : Any]
                        
                        // Writes connector object to Firebase.
                        ref.child("stations/\(id)/connectors/").child(connectorID).setValue(connector)
                        
                        // connector id number increment after connector has been created and written.
                        cID += 1
                    }
                    // station id number increment after station has beeb created and written
                    entryID += 1
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
        dispatchGroupFirebase.leave()
    }
    
    /// Function for getting data from EON API and writes that data to Firebase
    func fetchDataFromSuperchargeAPI() {
        
        // Variables needed for Firebase ID's
        var entryID = 0
        var cID = 0
        
        // Reference for Firebase.
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // URL for fetching data from eon api.
        guard let scUrl = URL(string: "https://supercharge.info/service/supercharge/allSites") else { return }
        
        URLSession.shared.dataTask(with: scUrl) {
            (data, reponse, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let scData = try decoder.decode([SuperchargeStation].self, from: data)
                
                // Will create a Station from each data entry returned from the api.
                for entry in scData {
                    
                    if entry.address.regionID == 101 {
                        // Variable for a station id in Firebase.
                        let id = String("sc-\(entryID)")
                        
                        // New station object for firebase.
                        let station = [
                            "name": entry.name,
                            "owner": "Tesla",
                            "latitude": entry.gps.latitude,
                            "longitude": entry.gps.longitude,
                            "streetAddress": entry.address.street,
                            "zipcode": Int(entry.address.zip ?? "") ?? 0,
                            "city": entry.address.city
                            ] as [String : Any]
                        
                        // Write station data to Firebase.
                        ref.child("stations").child(id).setValue(station)
                        
                        var number = entry.stallCount
                        
                        // Will create a connector from each connector entry in a station.
                        while number > 0 {
                            
                            // Variable for connector id in Firebase.
                            let connectorID = "connector-\(cID)"
                            
                            let status = String(Substring("No data available"))
                            
                            // New Connector object for Firebase.
                            let connector = [
                                "status": status,
                                "type 2": true,
                                "ccs": false,
                                "chademo": false
                                ] as [String : Any]
                            
                            // Writes connector object to Firebase.
                            ref.child("stations/\(id)/connectors/").child(connectorID).setValue(connector)
                            
                            // connector id number increment after connector has been created and written.
                            cID += 1
                            number -= 1
                        }
                        // station id number increment after station has beeb created and written
                        entryID += 1
                    }
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    
    // Function that fetches data from Firebase, asynchonously and appending the station data to stationData Array.
    func fetchStationsFromFirebase() {
        dispatchGroupFirebase.enter()
        var stationsArray: [Station] = []
        var ref = DatabaseReference()
        
        ref = Database.database().reference().child("stations")
        ref.observe(.value) { (snapshot) in
            let stations = snapshot.value as? NSDictionary
            for station in stations! {
                let stationObject = station.value as? NSDictionary
                var name = ""
                var owner = ""
                var latitude = ""
                var longitude = ""
                var streetAddress = ""
                var zipcode = ""
                var city = ""
                var connectorsArray: [StationConnector] = []
                for (key, value) in stationObject! {
                    let keyString = "\(key)"
                    let valueString = "\(value)"
                    if (keyString == "connectors") {
                        for (conKey, conValue) in value as! NSDictionary {
                            var status = ""
                            var type2 = false
                            var ccs = false
                            var chademo = false
                        
                            for (key, value) in conValue as! NSDictionary {
                                let connectorKeyString = "\(key)"
                                let connectorValueString = "\(value)"
                                
                                if connectorKeyString == "status" {
                                    status = (value as? String)!
                                }
                                if connectorKeyString == "type 2" {
                                    if connectorValueString == "1" {
                                        type2 = true
                                    }
                                }
                                if connectorKeyString == "ccs" {
                                    if connectorValueString == "1" {
                                        ccs = true
                                    }
                                }
                                if connectorKeyString == "chademo" {
                                    if connectorValueString == "1" {
                                        chademo = true
                                    }
                                }
                            }
                            let stationConnector = StationConnector(connectorID: conKey as! String, status: status, type2: type2, ccs: ccs, chademo: chademo)
                            connectorsArray.append(stationConnector)
                        }
                    }
                    if (keyString == "name") {
                        name = valueString
                    }
                    if (keyString == "owner") {
                        owner = valueString
                    }
                    if (keyString == "latitude") {
                        latitude = valueString
                    }
                    if (keyString == "longitude") {
                        longitude = valueString
                    }
                    if (keyString == "streetAddress") {
                        streetAddress = valueString
                    }
                    if (keyString == "zipcode") {
                        zipcode = valueString
                    }
                    if (keyString == "city") {
                        city = valueString
                    }
                }
                let station = Station(title: "annotation", owner: owner, streetAddress: streetAddress, zipcode: zipcode, city: city, coordinate: CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!), connectors: connectorsArray)
                stationsArray.append(station)
            }
            self.stationData = stationsArray
            self.dispatchGroupFirebase.leave()
        }
    }
}
