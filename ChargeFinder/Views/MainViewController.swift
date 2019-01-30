//
//  ViewController.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 29/08/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class MainViewController: UIViewController, CLLocationManagerDelegate, UIPopoverControllerDelegate, MKMapViewDelegate, FilterDelegate {
    
    /***************************************************************
     *  Function that controls what Staions are displayed on the map,
     *  with regards to Connector types.
     */
    func filter(type2: Bool, ccs: Bool, chademo: Bool, tesla: Bool) {
        self.showType2Annotations = type2
        self.showCcsAnnotations = ccs
        self.showChademoAnnotionations = chademo
        self.showTeslaAnnotations = tesla
        self.addStations(type2: showType2Annotations, ccs: showCcsAnnotations, chademo: showChademoAnnotionations, tesla: showTeslaAnnotations)
    }
    
    // Variables used for data from DataLoaderViewController.
    var dViewController: DataLoaderViewController!
    var data: [Station]!
    
    // TODO Variables that will control what types of annotations are shown
    var showType2Annotations = true
    var showCcsAnnotations = true
    var showChademoAnnotionations = true
    var showTeslaAnnotations = true
    
    // Variables for this View.
    let regionRadiius = CLLocationDistance(1000)
    var locationManager = CLLocationManager()
    var stationAnnotations = Set<Station>()
    var selectedAnnotation: Station!
    var selectedAnnotationCooridnate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    // Container View for info button
    lazy var infoButtonContainer: UIView = {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.14).cgColor
        let infoButtonViewContainer = UIView()
        infoButtonViewContainer.layer.cornerRadius = 31.5
        infoButtonViewContainer.layer.backgroundColor = color
        infoButtonViewContainer.translatesAutoresizingMaskIntoConstraints = false
        return infoButtonViewContainer
    }()
    
    // Info Button Setup.
    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_info"), for: .normal)
        button.addTarget(self, action: #selector(infoButtonPressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 29.5
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.22).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var filterButtonContainer: UIView = {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.14).cgColor
        let filterButtonViewContainer = UIView()
        filterButtonViewContainer.layer.cornerRadius = 31.5
        filterButtonViewContainer.layer.backgroundColor = color
        filterButtonViewContainer.translatesAutoresizingMaskIntoConstraints = false
        return filterButtonViewContainer
    }()
    
    // Filter Button.
    lazy var filterButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "navbar_settings_icon")
        let content = "    Filter"
        let font = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "FredokaOne-Regular", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
            ])
        button.addTarget(self, action: #selector(filterButtonPressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 29.5
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.setAttributedTitle(font, for: .normal)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ChargeFinder Logo
    lazy var cfLogoImage: UIImageView = {
        let image = UIImage(named: "chargefinder_logotype")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Outlet Variables
    @IBOutlet weak var mapView: MKMapView!
    
    /***************************************************************
     *  Responsible for loading UI elements and map setup
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewUIAssets()
        self.definesPresentationContext = true
        
        // User location
        mapView.showsUserLocation = true
        mapView.userLocation.title = "User"
        mapView.userTrackingMode = .follow
        mapView.register(StationClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("Device location service is turned off!")
        }
        mapView.delegate = self
        addStations(type2: showType2Annotations, ccs: showCcsAnnotations, chademo: showChademoAnnotionations, tesla: showTeslaAnnotations)
        mapViewDidFinishLoadingMap(mapView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /***************************************************************
     *  Adds location functionakity to map.
     */
    private func locationManager(_ manager: CLLocationManager, didUpdateLocation location: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location[0].coordinate.latitude, longitude: location[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.mapView.setRegion(region, animated: true)
        print(mapView.camera.altitude)
    }

    /***************************************************************
     *  will run if location tracking is not enabled.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Could not determine your current location!")
    }
    
    /***************************************************************
     *  Function for navigating to the correct view and managing what
     *  data is available for that view.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue for info view.
        if (segue.identifier == "infoSegue") {
            
            let destinationViewController = segue.destination as! InfoViewController
            destinationViewController.mViewController = self
            destinationViewController.modalPresentationStyle = .overCurrentContext
            destinationViewController.preferredContentSize = CGSize(width: 375, height: 749)
            
            let infoViewController = destinationViewController.popoverPresentationController
            infoViewController?.delegate = self as? UIPopoverPresentationControllerDelegate
        }
        
        // Segue for filter view.
        if (segue.identifier == "filterSegue") {
            
            let destinationViewController = segue.destination as! FilterViewController
            destinationViewController.mViewController = self
            destinationViewController.modalPresentationStyle = .overCurrentContext
            destinationViewController.preferredContentSize = CGSize(width: 375, height: 749)

            let filterViewController = destinationViewController.popoverPresentationController
            filterViewController?.delegate = self as? UIPopoverPresentationControllerDelegate
        }
        
        // Segue for annotation view.
        if (segue.identifier == "annotationSegue") {
            
            let destinationViewController = segue.destination as! AnnotationViewController
            destinationViewController.mViewController = self
            destinationViewController.modalPresentationStyle = .overCurrentContext
            destinationViewController.preferredContentSize = CGSize(width: 375, height: 749)
            destinationViewController.station = selectedAnnotation
            
            let annotationViewController = destinationViewController.popoverPresentationController
            annotationViewController?.delegate = self as? UIPopoverPresentationControllerDelegate
        }
    }
    
    /***************************************************************
     *  Function that sets the selected annotation for annotation
     *  view, and displays the correct data.
     */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // prevents using the segue on userLocation annotation on the map.
        if view.annotation?.title != "User" {
            if view.annotation?.title == "annotation" {
                selectedAnnotation = view.annotation as? Station
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
                if selectedAnnotation != view.annotation as? StationClusterView {
                    self.performSegue(withIdentifier: "annotationSegue", sender: self)
                } else {
                    if view.annotation?.coordinate != nil {
                        let cluster = view.annotation as? MKClusterAnnotation
                        let pins = cluster?.memberAnnotations
                        mapView.showAnnotations(pins!, animated: true)
                    }
                }
            }
        }
    }
    
    /***************************************************************
     *  Function that performs navigatopm to infoView.
     */
    @objc func infoButtonPressed(sender: UIButton) {
        self.performSegue(withIdentifier: "infoSegue", sender: self)
    }
    
    /***************************************************************
     *  Function that performs navigation to filterView. It also
     *  removes all annotations from the mapview.
     */
    @objc func filterButtonPressed(sender: UIButton) {
        removeStations()
        self.performSegue(withIdentifier: "filterSegue", sender: self)
    }
    
    /***************************************************************
     *  Adds UI Elements to the view.
     */
    func loadViewUIAssets() {
        view.addSubview(infoButtonContainer)
        infoButtonContainer.addSubview(infoButton)
        view.addSubview(filterButtonContainer)
        filterButtonContainer.addSubview(filterButton)
        view.addSubview(cfLogoImage)
    }
    
    /***************************************************************
     *  Handles UI constraints for this view and its elements.
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([

            // infoButtonContainer Constraints
            infoButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            infoButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            infoButtonContainer.widthAnchor.constraint(equalToConstant: 63),
            infoButtonContainer.heightAnchor.constraint(equalToConstant: 63),
            
            // InfoButton Constraints
            infoButton.centerYAnchor.constraint(equalTo: infoButtonContainer.centerYAnchor),
            infoButton.centerXAnchor.constraint(equalTo: infoButtonContainer.centerXAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 59),
            infoButton.heightAnchor.constraint(equalToConstant: 59),
            
            // Filter Button Constraints
            filterButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            filterButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            filterButtonContainer.widthAnchor.constraint(equalToConstant: 154),
            filterButtonContainer.heightAnchor.constraint(equalToConstant: 63),
            
            // filterButton Constraints
            filterButton.centerYAnchor.constraint(equalTo: filterButtonContainer.centerYAnchor),
            filterButton.centerXAnchor.constraint(equalTo: filterButtonContainer.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 150),
            filterButton.heightAnchor.constraint(equalToConstant: 59),
            
            // Charge Finder Logo Constraints
            cfLogoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            cfLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cfLogoImage.widthAnchor.constraint(equalToConstant: 147),
            cfLogoImage.heightAnchor.constraint(equalToConstant: 27),
        ])
    }

    /***************************************************************
     *  Adds Stations to the map, type parameters are used for
     *  filtering purposes.
     */
    func addStations(type2: Bool, ccs: Bool, chademo: Bool, tesla: Bool) {
        for station in data {
            if type2 == true {
                for connector in station.connectors! {
                    if connector.type2 == true && station.owner != "Tesla" {
                        self.mapView.addAnnotation(station)
                    }
                }
            }
            if ccs == true {
                for connector in station.connectors! {
                    if connector.ccs == true {
                        self.mapView.addAnnotation(station)
                    }
                }
            }
            if chademo == true {
                for connector in station.connectors! {
                    if connector.chademo == true {
                        self.mapView.addAnnotation(station)
                    }
                }
            }
            if tesla == true {
                for connector in station.connectors! {
                    if connector.type2 == true && station.owner == "Tesla" {
                        self.mapView.addAnnotation(station)
                    }
                }
            }
        }
    }
    
    /***************************************************************
     *  Removes all Station annotations from the map.
     */
    func removeStations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    /***************************************************************
     *  Set callout for userlocation annotation as false.
     */
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if let userLocationView = mapView.view(for: mapView.userLocation) {
            userLocationView.canShowCallout = false
        }
    }
    
    /***************************************************************
     *  Adds custom annotationViews for the map also sets identifier
     *  for clustering.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Station else { return nil }
        var type2IsAvailable = false
        var ccsIsAvailable = false
        var chademoIsAvailable = false
        var teslaIsAvailable = false
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotation.title != "User" {
            if (annotationView == nil) {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
            }
            if annotation.owner == "Tesla" {
                type2IsAvailable = false
                ccsIsAvailable = false
                chademoIsAvailable = false
                teslaIsAvailable = true
            } else {
                if let connector = annotation.connectors {
                    for connectors in connector {
                        if connectors.type2 == true {
                            type2IsAvailable = true
                        }
                        if connectors.ccs == true {
                            ccsIsAvailable = true
                        }
                        if connectors.chademo == true {
                            chademoIsAvailable = true
                        }
                        teslaIsAvailable = false
                    }
                }
            }
            annotationView?.clusteringIdentifier = "cluster"
            annotationView?.image = drawPin(type2: type2IsAvailable, ccs: ccsIsAvailable, chademo: chademoIsAvailable, tesla: teslaIsAvailable )
            annotationView?.canShowCallout = false
        }
        return annotationView
    }
    
    /***************************************************************
     *  Draws colors for annotationView image depending on what
     *  connector types are available.
     */
    func drawPin(type2: Bool, ccs: Bool, chademo: Bool, tesla: Bool) -> UIImage {

        // Type 2 = Green, CCS = Red, CHAdeMO = Blue, Default (none) = Grey
        let type2Color = UIColor(red: 0.29, green: 0.86, blue: 0.73, alpha: 1)
        let ccsColor = UIColor(red: 0.98, green: 0.79, blue: 0.15, alpha: 1)
        let chademoColor = UIColor(red: 0, green: 0.23, blue: 1, alpha: 1)
        let teslaColor = UIColor(red: 1, green: 0.33, blue: 0.18, alpha: 1)
        let defaultColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        
        let lineWidth: CGFloat = 1
        
        // Starting image
        let pinImage = UIImage(named: "pin")
        UIGraphicsBeginImageContextWithOptions(pinImage!.size, false, 0)
        
        pinImage?.draw(at: CGPoint.zero)
        // Connector indicator sizes
        let connectorWidth: CGFloat = 8
        let connectorHeight: CGFloat = 8
        // Upper Connector Indicator aka. TYPE 2
        let upperConnectorYPlacement: CGFloat = 13
        let upperConnectorXPlacement: CGFloat = (pinImage?.size.width)! / 2 - connectorWidth / 2
        // Left Connector Indicator aka. CCS & Right Connector Indicator aka. CHAdeMO
        let leftAndRightConnectorYPlacement: CGFloat = (pinImage?.size.height)! / 2 - 10
        let leftConnectorXPlacement: CGFloat = (pinImage?.size.width)! / 2 - connectorWidth - 4
        let rightConnectorXPlacement: CGFloat = (pinImage?.size.width)! / 2 + connectorWidth / 2
    
        // Lower Connector Indicator aka. Tesla
        let lowerIndicatorYPlacement: CGFloat = (pinImage?.size.width)! - 13 - connectorHeight / 2 - 2
        let lowerIndicatorXPlacement: CGFloat = (pinImage?.size.width)! / 2 - connectorWidth / 2
        
        let context = UIGraphicsGetCurrentContext()
        
        // Draw connector TYPE 2 on pin image (if available, should be Green, otherwise grey)
        if type2 {
            context?.setStrokeColor(type2Color.cgColor)
            context?.setFillColor(type2Color.cgColor)
        } else {
            context?.setStrokeColor(defaultColor.cgColor)
            context?.setFillColor(defaultColor.cgColor)
        }
        context?.setLineWidth(lineWidth)
        context?.addEllipse(in: CGRect(x: upperConnectorXPlacement, y: upperConnectorYPlacement, width: connectorWidth, height: connectorHeight))
        context?.drawPath(using: .fillStroke)
        
        // Draw connector CCS on pin image (if available, should be Red, otherwise grey)
        if ccs {
            context?.setStrokeColor(ccsColor.cgColor)
            context?.setFillColor(ccsColor.cgColor)
        } else {
            context?.setStrokeColor(defaultColor.cgColor)
            context?.setFillColor(defaultColor.cgColor)
        }
        context?.setLineWidth(lineWidth)
        context?.addEllipse(in: CGRect(x: leftConnectorXPlacement, y: leftAndRightConnectorYPlacement, width: connectorWidth, height: connectorHeight))
        context?.drawPath(using: .fillStroke)
        
        // Draw connector CHAdeMO on pin image (if available should be blue, otherwise grey)
        if chademo {
            context?.setStrokeColor(chademoColor.cgColor)
            context?.setFillColor(chademoColor.cgColor)
        } else {
            context?.setStrokeColor(defaultColor.cgColor)
            context?.setFillColor(defaultColor.cgColor)
        }
        context?.setLineWidth(lineWidth)
        context?.addEllipse(in: CGRect(x: rightConnectorXPlacement, y: leftAndRightConnectorYPlacement, width: connectorWidth, height: connectorHeight))
        context?.drawPath(using: .fillStroke)
        
        // Draw connector None Defined Type on pin image (always grey unless a fourth type connector is implemented.)
        if tesla {
            context?.setStrokeColor(teslaColor.cgColor)
            context?.setFillColor(teslaColor.cgColor)
        } else {
            context?.setStrokeColor(defaultColor.cgColor)
            context?.setFillColor(defaultColor.cgColor)
        }
        context?.setLineWidth(lineWidth)
        context?.addEllipse(in: CGRect(x: lowerIndicatorXPlacement, y: lowerIndicatorYPlacement, width: connectorWidth, height: connectorHeight))
        context?.drawPath(using: .fillStroke)
        
        // Pin Image after processing
        let finishedPin = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finishedPin!
    }
}

/***************************************************************
 *  Used for handling filtering communication between mainView
 *  and filterView.
 */
protocol FilterDelegate {
    func filter(type2: Bool, ccs: Bool, chademo: Bool, tesla: Bool)
}
