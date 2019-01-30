//
//  annotationViewController.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 04/09/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AnnotationViewController: UIViewController {
    
    @IBOutlet weak var navigationButtonContainer: UIView!
    
    var mViewController: MainViewController!

    var viewChargeStation: Station!
    var viewTitle: String!
    var subtitle: String!
    var station: Station?
    
    var type2Count = 0
    var ccsCount = 0
    var chademoCount = 0
    
    // Setup for the view.
    lazy var annotationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 63, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradient.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor
        ]
        gradient.locations = [0, 0.625883, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(gradient)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // An alternative option for closing this view, tapping the transparent upper part of the view.
    lazy var closeWindowButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.layer.zPosition = 2
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // An alternative option for closing this view, tapping the transparent upper part of the view.
    lazy var closeAnnotationWindowButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.layer.zPosition = 2
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Close Button Setup
    lazy var closeButton: UIButton = {
        let image = UIImage(named: "icon_close")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Navigation Button Setup
    lazy var navigationButton: UIButton = {
        let button = UIButton()
        let textColor = UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
        let image = UIImage(named: "icon_nav")
        let content = "  Navigate to this location"
        let font = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "FredokaOne-Regular", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
            ])
        button.addTarget(self, action: #selector(navigationButtonPressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 29.5
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.14).cgColor

        button.setImage(image, for: .normal)
        button.setAttributedTitle(font, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Container view for the 3 types of connectors.
    lazy var connectorContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Row for Type 2 Connector.
    lazy var type2RowContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Type 2 Image View.
    lazy var type2ImageView: UIImageView = {
        let image = UIImage(named: "plug_type2")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var type2Indicator: UIView = {
        let view = UIView()
        view.frame.size.width = 10.0
        view.frame.size.height = 10.0
        view.layer.cornerRadius = 0.5 * view.bounds.width
        if (station?.owner != "Tesla") {
            view.layer.backgroundColor = UIColor(red: 0.29, green: 0.86, blue: 0.73, alpha: 1).cgColor
        } else {
            view.layer.backgroundColor = UIColor(red: 1, green: 0.33, blue: 0.18, alpha: 1).cgColor
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var type2NumberOfConnectors: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 111, y: 607.5, width: 25, height: 25)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        let textContent = "\(type2Count)x"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        textString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range: textRange)
        label.attributedText = textString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var type2Label: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        var typeTextContent = ""
        if (station?.owner != "Tesla") {
            typeTextContent = "Type 2"
        } else {
            typeTextContent = "Tesla Supercharger"
        }
        let typeTextString = NSMutableAttributedString(string: typeTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let typeTextRange = NSRange(location: 0, length: typeTextString.length)
        let typeParagraphStyle = NSMutableParagraphStyle()
        typeParagraphStyle.lineSpacing = 1.39
        typeTextString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:typeParagraphStyle, range: typeTextRange)
        label.attributedText = typeTextString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ccsRowContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Type 2 Image View.
    lazy var ccsImageView: UIImageView = {
        let image = UIImage(named: "plug_ccs")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // CCS Indicator
    lazy var ccsIndicator: UIView = {
        let view = UIView()
        view.frame.size.width = 10.0
        view.frame.size.height = 10.0
        view.layer.cornerRadius = 0.5 * view.bounds.width
        view.layer.backgroundColor = UIColor(red: 0.98, green: 0.79, blue: 0.15, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // CCS label for displaying number of connectors
    lazy var ccsNumberOfConnectors: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 111, y: 607.5, width: 25, height: 25)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        let textContent = "\(ccsCount)x"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        textString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range: textRange)
        label.attributedText = textString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ccsLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        let typeTextContent = "CCS"
        let typeTextString = NSMutableAttributedString(string: typeTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let typeTextRange = NSRange(location: 0, length: typeTextString.length)
        let typeParagraphStyle = NSMutableParagraphStyle()
        typeParagraphStyle.lineSpacing = 1.39
        typeTextString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:typeParagraphStyle, range: typeTextRange)
        label.attributedText = typeTextString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var chademoRowContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Type 2 Image View.
    lazy var chademoImageView: UIImageView = {
        let image = UIImage(named: "plug_chademo")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var chademoIndicator: UIView = {
        let view = UIView()
        view.frame.size.width = 10.0
        view.frame.size.height = 10.0
        view.layer.cornerRadius = 0.5 * view.bounds.width
        view.layer.backgroundColor = UIColor(red:0, green:0.23, blue:1, alpha:1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var chademoNumberOfConnectors: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 111, y: 607.5, width: 25, height: 25)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        let textContent = "\(chademoCount)x"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        textString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range: textRange)
        label.attributedText = textString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var chademoLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        let typeTextContent = "CHAdeMO"
        let typeTextString = NSMutableAttributedString(string: typeTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let typeTextRange = NSRange(location: 0, length: typeTextString.length)
        let typeParagraphStyle = NSMutableParagraphStyle()
        typeParagraphStyle.lineSpacing = 1.39
        typeTextString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:typeParagraphStyle, range: typeTextRange)
        label.attributedText = typeTextString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Label for displaying who owns the charging station.
    lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.text = "Operated by \(station?.owner ?? "No Data")"
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Title Label for the stations name.
    lazy var annotationTitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
        let textContent = "\(station?.streetAddress ?? "No Station Title")"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "FredokaOne-Regular", size: 28)!
        ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.21
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        label.attributedText = textString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Closing this popover view.
    @objc func closeView(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function that passes station data and opens Maps app with navigation.
    @objc func navigationButtonPressed(sender: UIButton!) {
        let latitude = station?.coordinate.latitude
        let longitude = station?.coordinate.longitude
        
        let regionDistance: CLLocationDistance = 500
        let coordinates = CLLocationCoordinate2DMake(latitude!, longitude!)
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let markLocation = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: markLocation)
        mapItem.name = station?.title
        mapItem.openInMaps(launchOptions: options)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        connectorCounter()
        setLayoutForDetailView()
    }

    
    func connectorCounter() {
        if (station?.connectors?.count ?? 0) > 0 {
            for connector in (station?.connectors)! {
                if connector.type2 == true {
                    type2Count += 1
                }
                if connector.ccs == true {
                    ccsCount += 1
                }
                if connector.chademo == true {
                    chademoCount += 1
                }
            }
        } else {
            print("No connectors for this station!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adds the UI Items to the view.
    func setLayoutForDetailView() {
        
        // Basic ui elements need for the view.
        view.addSubview(annotationView)
        annotationView.addSubview(closeAnnotationWindowButton)
        annotationView.addSubview(closeButton)
        annotationView.addSubview(navigationButton)
        annotationView.addSubview(connectorContainer)
        annotationView.addSubview(annotationTitleLabel)
        annotationView.addSubview(ownerLabel)
        connectorContainer.addSubview(type2RowContainer)
        connectorContainer.addSubview(ccsRowContainer)
        connectorContainer.addSubview(chademoRowContainer)
        
        // CONDITIONAL UI ELEMENTS FOR TYPE 2 and TESLA
        // Will add Type 2 and Tesla ui assets if the station has this type.
        if type2Count > 0 {
            type2RowContainer.addSubview(type2ImageView)
            type2RowContainer.addSubview(type2Indicator)
            type2RowContainer.addSubview(type2NumberOfConnectors)
            type2RowContainer.addSubview(type2Label)
        }
        
        // CONDITIONAL UI ELEMENTS FOR CCS
        // Will add ccs ui assets if the station has this type.
        if ccsCount > 0 {
            ccsRowContainer.addSubview(ccsImageView)
            ccsRowContainer.addSubview(ccsIndicator)
            ccsRowContainer.addSubview(ccsNumberOfConnectors)
            ccsRowContainer.addSubview(ccsLabel)
        }
        
        // CONDITIONAL UI ELEMENTS FOR CHAdeMO
        // Will add chademo ui assets if the station has this type.
        if chademoCount > 0 {
            chademoRowContainer.addSubview(chademoImageView)
            chademoRowContainer.addSubview(chademoIndicator)
            chademoRowContainer.addSubview(chademoNumberOfConnectors)
            chademoRowContainer.addSubview(chademoLabel)
        }
    }
    
    /***************************************************************
     *  This function is used for setting ui constraints, some of
     *  them are set when a certain condition has been met.
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var renderType2 = false
        var renderCcs = false
        var renderChademo = false
        
        if type2Count > 0 {
            renderType2 = true
        }
        
        if ccsCount > 0 {
            renderCcs = true
        }
        
        if chademoCount > 0 {
            renderChademo = true
        }

        let conHeight: Double = 50
        var connectorContainerHeight: Double = 0
        let rowContainerHeight: Double = 50
        let indicatorHeight: Double = 10
        
        if renderType2 {
            connectorContainerHeight += conHeight
        }
        
        if renderCcs {
            connectorContainerHeight += conHeight
        }
        
        if renderChademo {
            connectorContainerHeight += conHeight
        }
        
        if renderType2 && !renderCcs && !renderChademo {
            connectorContainerHeight = conHeight * 2
        }
        

        
        // Constraints set when the view appears.
        NSLayoutConstraint.activate([
            // Annotation View Container Constraints
            annotationView.topAnchor.constraint(equalTo: view.topAnchor),
            annotationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            annotationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            annotationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Navigation Button Constraints
            navigationButton.centerXAnchor.constraint(equalTo: annotationView.centerXAnchor),
            navigationButton.bottomAnchor.constraint(equalTo: annotationView.bottomAnchor, constant: -22),
            navigationButton.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor, constant: 22),
            navigationButton.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: -22),
            navigationButton.heightAnchor.constraint(equalToConstant: 59),
            
            // Connector Container Constraints
            connectorContainer.bottomAnchor.constraint(equalTo: navigationButton.topAnchor, constant: -20),
            connectorContainer.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor, constant: 31),
            connectorContainer.heightAnchor.constraint(equalToConstant: CGFloat(connectorContainerHeight)),
            connectorContainer.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: -31),
            
            // Owner Label Constraints
            ownerLabel.bottomAnchor.constraint(equalTo: connectorContainer.topAnchor, constant: -25),
            ownerLabel.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor, constant: 31),
            ownerLabel.heightAnchor.constraint(equalToConstant: 25),
            ownerLabel.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: -31),
            
            closeAnnotationWindowButton.topAnchor.constraint(equalTo: annotationView.topAnchor),
            closeAnnotationWindowButton.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor),
            closeAnnotationWindowButton.bottomAnchor.constraint(equalTo: annotationTitleLabel.topAnchor),
            closeAnnotationWindowButton.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor),
            
            // Close Button Constraints
            closeButton.centerYAnchor.constraint(equalTo: annotationTitleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: -31),
            closeButton.widthAnchor.constraint(equalToConstant: 29),
            closeButton.heightAnchor.constraint(equalToConstant: 29),
        ])
        
        // Annotation Title Label Constraints
        if ((annotationTitleLabel.attributedText?.length)! > 20) {
            NSLayoutConstraint.activate([
                annotationTitleLabel.heightAnchor.constraint(equalToConstant: 100),
            ])
        } else {
            NSLayoutConstraint.activate([
                annotationTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
        NSLayoutConstraint.activate([
            annotationTitleLabel.bottomAnchor.constraint(equalTo: ownerLabel.topAnchor, constant: -5),
            annotationTitleLabel.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor, constant: 31),
            annotationTitleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -50),
        ])
        
        // CONDITIONAL CONSTRAINTS FOR TYPE 2
        // Type 2 Row constraints will be set, if the current station has at least 1 of this, this will also be used
        // if the station owner is Tesla. A normal Type 2 station will never be a Tesla Station.
        if renderType2 {
            NSLayoutConstraint.activate([
                // Type 2 Row Container Constraints
                type2RowContainer.topAnchor.constraint(equalTo: connectorContainer.topAnchor),
                type2RowContainer.leadingAnchor.constraint(equalTo: connectorContainer.leadingAnchor),
                type2RowContainer.heightAnchor.constraint(equalToConstant: CGFloat(rowContainerHeight)),
                type2RowContainer.trailingAnchor.constraint(equalTo: connectorContainer.trailingAnchor),
                
                // Type 2 ImageView Constraints
                type2ImageView.centerYAnchor.constraint(equalTo: type2RowContainer.centerYAnchor),
                type2ImageView.leadingAnchor.constraint(equalTo: type2RowContainer.leadingAnchor, constant: 2),
                type2ImageView.widthAnchor.constraint(equalToConstant: 37),
                
                // Type 2 Indicator Constraints
                type2Indicator.centerYAnchor.constraint(equalTo: type2RowContainer.centerYAnchor),
                type2Indicator.leadingAnchor.constraint(equalTo: type2ImageView.trailingAnchor, constant: 18),
                type2Indicator.heightAnchor.constraint(equalToConstant: CGFloat(indicatorHeight)),
                type2Indicator.widthAnchor.constraint(equalToConstant: 10),
                
                // Type 2 Count Label Constraints
                type2NumberOfConnectors.topAnchor.constraint(equalTo: type2RowContainer.topAnchor),
                type2NumberOfConnectors.leadingAnchor.constraint(equalTo: type2Indicator.trailingAnchor, constant: 9),
                type2NumberOfConnectors.bottomAnchor.constraint(equalTo: type2RowContainer.bottomAnchor),
                type2NumberOfConnectors.widthAnchor.constraint(equalToConstant: 25),
                
                // Type 2 Type Label Constraints
                type2Label.topAnchor.constraint(equalTo: type2RowContainer.topAnchor),
                type2Label.leadingAnchor.constraint(equalTo: type2NumberOfConnectors.trailingAnchor, constant: 10),
                type2Label.bottomAnchor.constraint(equalTo: type2RowContainer.bottomAnchor),
                type2Label.trailingAnchor.constraint(equalTo: type2RowContainer.trailingAnchor),
            ])
        }
        
        // CONDITIONAL CONSTRAINTS FOR CCS
        // CCS Row constraints will be set, if the current station has at least 1 of this
        if renderCcs {
            if renderType2 {
                NSLayoutConstraint.activate([
                    ccsRowContainer.topAnchor.constraint(equalTo: type2RowContainer.bottomAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    ccsRowContainer.topAnchor.constraint(equalTo: connectorContainer.topAnchor)
                ])
            }
            NSLayoutConstraint.activate([
                // CCS Row Container Constraints
                ccsRowContainer.leadingAnchor.constraint(equalTo: connectorContainer.leadingAnchor),
                ccsRowContainer.heightAnchor.constraint(equalToConstant: CGFloat(rowContainerHeight)),
                ccsRowContainer.trailingAnchor.constraint(equalTo: connectorContainer.trailingAnchor),
                
                // CCS ImageView Constraints
                ccsImageView.centerYAnchor.constraint(equalTo: ccsRowContainer.centerYAnchor),
                ccsImageView.centerXAnchor.constraint(equalTo: type2ImageView.centerXAnchor),
                
                // CCS Indicator Constraints
                ccsIndicator.centerYAnchor.constraint(equalTo: ccsRowContainer.centerYAnchor),
                ccsIndicator.centerXAnchor.constraint(equalTo: type2Indicator.centerXAnchor),
                ccsIndicator.heightAnchor.constraint(equalToConstant: CGFloat(indicatorHeight)),
                ccsIndicator.widthAnchor.constraint(equalToConstant: 10),
                
                // CCS Count Label Constraints
                ccsNumberOfConnectors.topAnchor.constraint(equalTo: ccsRowContainer.topAnchor),
                ccsNumberOfConnectors.leadingAnchor.constraint(equalTo: ccsIndicator.trailingAnchor, constant: 9),
                ccsNumberOfConnectors.bottomAnchor.constraint(equalTo: ccsRowContainer.bottomAnchor),
                ccsNumberOfConnectors.widthAnchor.constraint(equalToConstant: 25),
                
                // CCS Type Label Constraints
                ccsLabel.topAnchor.constraint(equalTo: ccsRowContainer.topAnchor),
                ccsLabel.leadingAnchor.constraint(equalTo: ccsNumberOfConnectors.trailingAnchor, constant: 10),
                ccsLabel.bottomAnchor.constraint(equalTo: ccsRowContainer.bottomAnchor),
                ccsLabel.trailingAnchor.constraint(equalTo: ccsRowContainer.trailingAnchor),
            ])
        }
        
        // CONDITIONAÆ CONSTRAINTS FOR CHAdeMO
        // CHAdeMO Row constraints will be set, if the current station has at least 1 of this
        if renderChademo {
            if renderCcs {
                NSLayoutConstraint.activate([
                    chademoRowContainer.topAnchor.constraint(equalTo: ccsRowContainer.bottomAnchor)
                ])
            } else if (!renderCcs && !renderType2) {
                NSLayoutConstraint.activate([
                    chademoRowContainer.topAnchor.constraint(equalTo: type2RowContainer.bottomAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    chademoRowContainer.topAnchor.constraint(equalTo: connectorContainer.topAnchor),
                ])
            }
            NSLayoutConstraint.activate([
                // CCS Row Container Constraints
                chademoRowContainer.leadingAnchor.constraint(equalTo: connectorContainer.leadingAnchor),
                chademoRowContainer.heightAnchor.constraint(equalToConstant: CGFloat(rowContainerHeight)),
                chademoRowContainer.trailingAnchor.constraint(equalTo: connectorContainer.trailingAnchor),
                
                // CCS ImageView Constraints
                chademoImageView.centerYAnchor.constraint(equalTo: chademoRowContainer.centerYAnchor),
                chademoImageView.centerXAnchor.constraint(equalTo: type2ImageView.centerXAnchor),
                
                // CCS Indicator Constraints
                chademoIndicator.centerYAnchor.constraint(equalTo: chademoRowContainer.centerYAnchor),
                chademoIndicator.centerXAnchor.constraint(equalTo: type2Indicator.centerXAnchor),
                chademoIndicator.heightAnchor.constraint(equalToConstant: CGFloat(indicatorHeight)),
                chademoIndicator.widthAnchor.constraint(equalToConstant: 10),
                
                // CCS Count Label Constraints
                chademoNumberOfConnectors.topAnchor.constraint(equalTo: chademoRowContainer.topAnchor),
                chademoNumberOfConnectors.leadingAnchor.constraint(equalTo: chademoIndicator.trailingAnchor, constant: 9),
                chademoNumberOfConnectors.bottomAnchor.constraint(equalTo: chademoRowContainer.bottomAnchor),
                chademoNumberOfConnectors.widthAnchor.constraint(equalToConstant: 25),
                
                // CCS Type Label Constraints
                chademoLabel.topAnchor.constraint(equalTo: chademoRowContainer.topAnchor),
                chademoLabel.leadingAnchor.constraint(equalTo: chademoNumberOfConnectors.trailingAnchor, constant: 10),
                chademoLabel.bottomAnchor.constraint(equalTo: chademoRowContainer.bottomAnchor),
                chademoLabel.trailingAnchor.constraint(equalTo: chademoRowContainer.trailingAnchor),
            ])
        }
    }
}
