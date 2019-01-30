//
//  FilterViewController.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 29/08/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var mViewController: MainViewController!
    
    // Filter Types are set to true as default.
    var showType2Annotations = true
    var showCCSAnnotations = true
    var showCHAdeMOAnnotations = true
    var showTeslaAnnotations = true
    
    // Determines whether Type 2 is true or false.
    func setType2() {
        showType2Annotations = mViewController.showType2Annotations
    }
    
    // Determines whether CCS is true or false.
    func setCCS() {
        showCCSAnnotations = mViewController.showCcsAnnotations
    }
    
    // Determines whether CHAdeMO is true or false.
    func setChademo() {
        showCHAdeMOAnnotations = mViewController.showChademoAnnotionations
    }
    
    func setTesla() {
        showTeslaAnnotations = mViewController.showTeslaAnnotations
    }
    
    // Base View
    lazy var filterView: UIView = {
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
    
    // Close Button Setup
    lazy var closeButton: UIButton = {
        let image = UIImage(named: "icon_close")
        let button = UIButton()
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 14.5
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.layer.zPosition = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Info View Label Setup
    lazy var filterViewLabel: UILabel = {
        let content = "Filter\noptions"
        let font = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "FredokaOne-Regular", size: 28)!
            ])
        let range = NSRange(location: 0, length: font.length)
        let color = UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        let label = UILabel()
        label.attributedText = font
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Container for all UI Assets relating to filters.
    lazy var filtersContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Container for the UI assets for a TYPE 2 assets
    lazy var type2Container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Image showing TYPE 2 Connector icon
    lazy var type2Image: UIImageView = {
        let image = UIImage(named: "plug_type2")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Color Indicator for TYPE 2
    lazy var type2Indicator: UIView = {
        let color = UIColor(red:0.29, green:0.86, blue:0.73, alpha:1)
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = color
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Label for ui displaying TYPE 2
    lazy var type2filterLabel: UILabel = {
        let content = "Type 2"
        let font = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let range = NSRange(location: 0, length: font.length)
        let color = UIColor.darkGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        let label = UILabel()
        label.attributedText = font
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Switch for TYPE 2 Filter
    lazy var type2FilterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        if (showType2Annotations == true) {
            filterSwitch.setOn(true, animated: true)
        } else {
            filterSwitch.setOn(false, animated: true)
        }
        filterSwitch.onTintColor = UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.addTarget(self, action: #selector(type2Switch), for: .touchUpInside)
        return filterSwitch
    }()
    
    // Container for the UI assets for a CCS assets
    lazy var ccsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Image showing CCS Connector icon
    lazy var ccsImage: UIImageView = {
        let image = UIImage(named: "plug_ccs")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Color Indicator for CCS
    lazy var ccsIndicator: UIView = {
        let color = UIColor(red: 0.98, green: 0.79, blue: 0.15, alpha: 1)
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = color
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Label for ui displaying CCS
    lazy var ccsfilterLabel: UILabel = {
        let content = "CCS"
        let font = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let range = NSRange(location: 0, length: font.length)
        let color = UIColor.darkGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        let label = UILabel()
        label.attributedText = font
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Switch for CCS Filter
    lazy var ccsFilterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        if (showCCSAnnotations == true) {
            filterSwitch.setOn(true, animated: true)
        } else {
            filterSwitch.setOn(false, animated: true)
        }
        filterSwitch.onTintColor = UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.addTarget(self, action: #selector(ccsSwitch), for: .touchUpInside)
        return filterSwitch
    }()
    
    // Container for the UI assets for a CHAdeMO assets
    lazy var chademoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Image showing CHAdeMO Connector icon
    lazy var chademoImage: UIImageView = {
        let image = UIImage(named: "plug_chademo")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Color Indicator for CHAdeMO
    lazy var chademoIndicator: UIView = {
        let color = UIColor(red:0, green:0.23, blue:1, alpha:1)
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = color
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Label for ui displaying CHAdeMO
    lazy var chademofilterLabel: UILabel = {
        let content = "CHAdeMO"
        let font = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let range = NSRange(location: 0, length: font.length)
        let color = UIColor.darkGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        let label = UILabel()
        label.attributedText = font
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Switch fo CHAdeMO Filter
    lazy var chademoFilterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        if showCHAdeMOAnnotations == true {
            filterSwitch.setOn(true, animated: true)
        } else {
            filterSwitch.setOn(false, animated: true)
        }
        filterSwitch.onTintColor = UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.addTarget(self, action: #selector(chademoSwitch), for: .touchUpInside)
        return filterSwitch
    }()
    
    lazy var teslaContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var teslaImage: UIImageView = {
        let image = UIImage(named: "plug_type2")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var teslaIndicator: UIView = {
        let color = UIColor(red: 1, green: 0.33, blue: 0.18, alpha: 1)
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = color
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Label for ui displaying CHAdeMO
    lazy var teslaFilterLabel: UILabel = {
        var content = "Tesla"
        if view.frame.width > 320 {
            content = "Tesla Supercharger"
        }
        let font = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let range = NSRange(location: 0, length: font.length)
        let color = UIColor.darkGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        let label = UILabel()
        label.attributedText = font
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Switch fo Tesla Filter
    lazy var teslaFilterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        if showTeslaAnnotations == true {
            filterSwitch.setOn(true, animated: true)
        } else {
            filterSwitch.setOn(false, animated: true)
        }
        filterSwitch.onTintColor = UIColor(red: 0.29, green: 0, blue: 1, alpha: 1)
        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.addTarget(self, action: #selector(teslaSwitch), for: .touchUpInside)
        return filterSwitch
    }()
    
    @objc func closeView(sender: UIButton!) {
        mViewController.filter(type2: showType2Annotations, ccs: showCCSAnnotations, chademo: showCHAdeMOAnnotations, tesla: showTeslaAnnotations)
        //self.dismiss(animated: true, completion: nil)
        /*
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
 */
        let newFrame = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.frame = newFrame
        UIView.animate(withDuration: 2, animations: {
            self.mViewController.view.layoutIfNeeded()
        }) { (completed) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // TODO: Should handle weather stations with connector Type 2 should be shown.
    @objc func type2Switch(sender: UISwitch) {
        if (type2FilterSwitch.isOn) {
            showType2Annotations = true
        } else {
            showType2Annotations = false
        }
    }
    
    // TODO: Should handle weather stations with connector CCS should be shown.
    @objc func ccsSwitch(sender: UISwitch) {
        if (ccsFilterSwitch.isOn) {
            showCCSAnnotations = true
        } else {
            showCCSAnnotations = false
        }
    }
    
    // TODO: Should handle weather stations with connector CHAdeMO should be shown.
    @objc func chademoSwitch(sender: UISwitch) {
        if (chademoFilterSwitch.isOn) {
            showCHAdeMOAnnotations = true
        } else {
            showCHAdeMOAnnotations = false
        }
    }
    
    // TODO: Should handle weather stations with connector CHAdeMO should be shown.
    @objc func teslaSwitch(sender: UISwitch) {
        if (teslaFilterSwitch.isOn) {
            showTeslaAnnotations = true
        } else {
            showTeslaAnnotations = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        setType2()
        setCCS()
        setChademo()
        setTesla()
        setLayoutForFilterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Loads UI Assets
    func setLayoutForFilterView() {
        view.addSubview(filterView)
        filterView.addSubview(closeWindowButton)
        filterView.addSubview(closeButton)
        filterView.addSubview(filterViewLabel)
        filterView.addSubview(filtersContainer)
        filtersContainer.addSubview(type2Container)
        filtersContainer.addSubview(ccsContainer)
        filtersContainer.addSubview(chademoContainer)
        filtersContainer.addSubview(teslaContainer)
        type2Container.addSubview(type2Image)
        type2Container.addSubview(type2Indicator)
        type2Container.addSubview(type2filterLabel)
        type2Container.addSubview(type2FilterSwitch)
        ccsContainer.addSubview(ccsImage)
        ccsContainer.addSubview(ccsIndicator)
        ccsContainer.addSubview(ccsfilterLabel)
        ccsContainer.addSubview(ccsFilterSwitch)
        chademoContainer.addSubview(chademoImage)
        chademoContainer.addSubview(chademoIndicator)
        chademoContainer.addSubview(chademofilterLabel)
        chademoContainer.addSubview(chademoFilterSwitch)
        teslaContainer.addSubview(teslaImage)
        teslaContainer.addSubview(teslaIndicator)
        teslaContainer.addSubview(teslaFilterLabel)
        teslaContainer.addSubview(teslaFilterSwitch)
    }
    
    // Constraints for assets of this view.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            // View Constraints
            filterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            filterView.topAnchor.constraint(equalTo: view.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // closeWindowButton, invisible button at the top of the screen, where the map is visible.
            closeWindowButton.topAnchor.constraint(equalTo: filterView.topAnchor),
            closeWindowButton.trailingAnchor.constraint(equalTo: filterView.trailingAnchor),
            closeWindowButton.bottomAnchor.constraint(equalTo: filterViewLabel.topAnchor),
            closeWindowButton.leadingAnchor.constraint(equalTo: filterView.leadingAnchor),
            
            // closeButton Constraints
            closeButton.centerYAnchor.constraint(equalTo: filterViewLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -31.0),
            closeButton.widthAnchor.constraint(equalToConstant: 29.0),
            closeButton.heightAnchor.constraint(equalToConstant: 29.0),
            
            // infoViewLabel Constraints
            filterViewLabel.bottomAnchor.constraint(equalTo: type2Container.topAnchor, constant: -15),
            filterViewLabel.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 31.0),
            filterViewLabel.heightAnchor.constraint(equalToConstant: 68.0),
            filterViewLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -5),
            
            // filter container Constraints
            filtersContainer.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
            filtersContainer.topAnchor.constraint(equalTo: filterViewLabel.bottomAnchor),
            filtersContainer.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 31.0),
            filtersContainer.bottomAnchor.constraint(equalTo: filterView.bottomAnchor, constant: -25.0),
            filtersContainer.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -31.0),
            
            // Type 2 Connector Container constraints
            type2Container.heightAnchor.constraint(equalToConstant: 50.0),
            type2Container.bottomAnchor.constraint(equalTo: ccsContainer.topAnchor, constant: -25.0),
            type2Container.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            type2Container.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            // Type 2 Image Constraints
            type2Image.centerYAnchor.constraint(equalTo: type2Container.centerYAnchor),
            type2Image.leadingAnchor.constraint(equalTo: type2Container.leadingAnchor),
            type2Image.heightAnchor.constraint(equalToConstant: 33),
            type2Image.widthAnchor.constraint(equalToConstant: 37),
            // Type 2 Indicator Constraints
            type2Indicator.centerYAnchor.constraint(equalTo: type2Container.centerYAnchor),
            type2Indicator.leadingAnchor.constraint(equalTo: type2Container.leadingAnchor, constant: 50.0),
            type2Indicator.heightAnchor.constraint(equalToConstant: 10),
            type2Indicator.widthAnchor.constraint(equalToConstant: 10),
            // Type 2 Filter Label Constraints
            type2filterLabel.centerYAnchor.constraint(equalTo: type2Container.centerYAnchor),
            type2filterLabel.leadingAnchor.constraint(equalTo: type2Container.leadingAnchor, constant: 75.0),
            type2filterLabel.heightAnchor.constraint(equalToConstant: 25),
            type2filterLabel.widthAnchor.constraint(equalToConstant: 100),
            // Type 2 Switch Contstraints
            type2FilterSwitch.centerYAnchor.constraint(equalTo: type2Container.centerYAnchor),
            type2FilterSwitch.trailingAnchor.constraint(equalTo: type2Container.trailingAnchor),
            
            // CCS Connector Container constraints
            ccsContainer.heightAnchor.constraint(equalToConstant: 50.0),
            ccsContainer.bottomAnchor.constraint(equalTo: chademoContainer.topAnchor, constant: -25.0),
            ccsContainer.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            ccsContainer.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            // CCS Image Constraints
            ccsImage.centerYAnchor.constraint(equalTo: ccsContainer.centerYAnchor),
            ccsImage.leadingAnchor.constraint(equalTo: ccsContainer.leadingAnchor, constant: 0.0),
            ccsImage.heightAnchor.constraint(equalToConstant: 40.0),
            ccsImage.widthAnchor.constraint(equalToConstant: 29.0),
            // CCS Indicator Constraints
            ccsIndicator.centerYAnchor.constraint(equalTo: ccsContainer.centerYAnchor),
            ccsIndicator.leadingAnchor.constraint(equalTo: ccsContainer.leadingAnchor, constant: 50.0),
            ccsIndicator.heightAnchor.constraint(equalToConstant: 10),
            ccsIndicator.widthAnchor.constraint(equalToConstant: 10),
            // CCS Filter Label Constraints
            ccsfilterLabel.centerYAnchor.constraint(equalTo: ccsContainer.centerYAnchor),
            ccsfilterLabel.leadingAnchor.constraint(equalTo: ccsContainer.leadingAnchor, constant: 75.0),
            ccsfilterLabel.heightAnchor.constraint(equalToConstant: 25),
            ccsfilterLabel.widthAnchor.constraint(equalToConstant: 100),
            // CCS Switch Contstraints
            ccsFilterSwitch.centerYAnchor.constraint(equalTo: ccsContainer.centerYAnchor),
            ccsFilterSwitch.trailingAnchor.constraint(equalTo: ccsContainer.trailingAnchor),
            
            // CHAdeMO Connector Container constraints
            chademoContainer.heightAnchor.constraint(equalToConstant: 50.0),
            chademoContainer.bottomAnchor.constraint(equalTo: teslaContainer.topAnchor, constant: -25.0),
            chademoContainer.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            chademoContainer.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            // CHAdeMO Image Constraints
            chademoImage.centerYAnchor.constraint(equalTo: chademoContainer.centerYAnchor),
            chademoImage.leadingAnchor.constraint(equalTo: chademoContainer.leadingAnchor),
            chademoImage.heightAnchor.constraint(equalToConstant: 35),
            chademoImage.widthAnchor.constraint(equalToConstant: 35),
            // CHAdeMO Indicator Constraints
            chademoIndicator.centerYAnchor.constraint(equalTo: chademoContainer.centerYAnchor),
            chademoIndicator.leadingAnchor.constraint(equalTo: chademoContainer.leadingAnchor, constant: 50.0),
            chademoIndicator.heightAnchor.constraint(equalToConstant: 10),
            chademoIndicator.widthAnchor.constraint(equalToConstant: 10),
            // CHAdeMO Filter Label Constraints
            chademofilterLabel.centerYAnchor.constraint(equalTo: chademoContainer.centerYAnchor),
            chademofilterLabel.leadingAnchor.constraint(equalTo: chademoContainer.leadingAnchor, constant: 75.0),
            chademofilterLabel.heightAnchor.constraint(equalToConstant: 25),
            chademofilterLabel.widthAnchor.constraint(equalToConstant: 100),
            // CHAdeMO Switch Contstraints
            chademoFilterSwitch.centerYAnchor.constraint(equalTo: chademoContainer.centerYAnchor),
            chademoFilterSwitch.trailingAnchor.constraint(equalTo: chademoContainer.trailingAnchor, constant: 0),
            
            // Tesla Conntector Container contstraints
            teslaContainer.heightAnchor.constraint(equalToConstant: 50),
            teslaContainer.bottomAnchor.constraint(equalTo: filtersContainer.bottomAnchor),
            teslaContainer.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            teslaContainer.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            // Tesla Image Constraints
            teslaImage.centerYAnchor.constraint(equalTo: teslaContainer.centerYAnchor),
            teslaImage.leadingAnchor.constraint(equalTo: teslaContainer.leadingAnchor),
            teslaImage.heightAnchor.constraint(equalToConstant: 33),
            teslaImage.widthAnchor.constraint(equalToConstant: 37),
            // Tesla Indicator Constraints
            teslaIndicator.centerYAnchor.constraint(equalTo: teslaContainer.centerYAnchor),
            teslaIndicator.leadingAnchor.constraint(equalTo: teslaContainer.leadingAnchor, constant: 50.0),
            teslaIndicator.heightAnchor.constraint(equalToConstant: 10),
            teslaIndicator.widthAnchor.constraint(equalToConstant: 10),
            // Tesla Filter Label Constraints
            teslaFilterLabel.centerYAnchor.constraint(equalTo: teslaContainer.centerYAnchor),
            teslaFilterLabel.leadingAnchor.constraint(equalTo: teslaContainer.leadingAnchor, constant: 75.0),
            teslaFilterLabel.heightAnchor.constraint(equalToConstant: 25),
            teslaFilterLabel.widthAnchor.constraint(equalToConstant: 200),
            // Tesla Switch constraints
            teslaFilterSwitch.centerYAnchor.constraint(equalTo: teslaContainer.centerYAnchor),
            teslaFilterSwitch.trailingAnchor.constraint(equalTo: teslaContainer.trailingAnchor),
        ])
    }
}
