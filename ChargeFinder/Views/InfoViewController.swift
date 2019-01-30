//
//  InfoViewController.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 29/08/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var mViewController: MainViewController!
    
    // Info View Container Setup
    lazy var infoViewContainer: UIView = {
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
        
        let view = UIView()
        view.layer.addSublayer(gradient)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Info View Label Setup
    lazy var infoViewLabel: UILabel = {
        let content = "About\nthe app"
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
    
    // Logo Setup
    lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "about_novasa_seal")
        let imageView = UIImageView()
        imageView.image = image
        imageView.layer.zPosition = 1
        imageView.alpha = 0.75
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // TextArea Setup
    lazy var textArea: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        let textAbout = "This app was made for the electric car owners, and enthusiasts of Europe. The app currently supports annotating charge stations in Europe by Tesla, E.ON stations in Denmark, and Clever stations in both Denmark and Sweden."
        let textCreator = "ChargeFinder app was made by Tommy Troest as internship project for Novasa in 2018."
        let textContent = "\(textAbout)\n\n\(textCreator)"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 18)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.39
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        label.attributedText = textString
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Close Button Action
    @objc func closeView(sender: UIButton!) {
        let transition: CATransition = CATransition()
        transition.duration = 0.8
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        setLayoutForInfoView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Adds UI items to this view.
    func setLayoutForInfoView() {
        view.addSubview(infoViewContainer)
        infoViewContainer.addSubview(closeWindowButton)
        infoViewContainer.addSubview(closeButton)
        infoViewContainer.addSubview(infoViewLabel)
        infoViewContainer.addSubview(logoImageView)
        infoViewContainer.addSubview(textArea)
    }
    
    // Handling constraints for this view.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var logoSpacingBottom: CGFloat = -50
        var textAreaSpacingBottom: CGFloat = -30
        var infoLabelSpacingBottom: CGFloat = -30
        
        if view.frame.size.height <= 1150 {
            logoSpacingBottom = -25
            textAreaSpacingBottom = -15
            infoLabelSpacingBottom = -15
        }
        
        NSLayoutConstraint.activate([
            // infoViewContainer constraints
            infoViewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoViewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            infoViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            closeWindowButton.topAnchor.constraint(equalTo: infoViewContainer.topAnchor),
            closeWindowButton.leadingAnchor.constraint(equalTo: infoViewContainer.leadingAnchor),
            closeWindowButton.bottomAnchor.constraint(equalTo: infoViewLabel.topAnchor),
            closeWindowButton.trailingAnchor.constraint(equalTo: infoViewContainer.trailingAnchor),

            // logoImageView Constraints
            logoImageView.centerXAnchor.constraint(equalTo: infoViewContainer.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 68.0),
            logoImageView.widthAnchor.constraint(equalToConstant: 81.0),
            logoImageView.bottomAnchor.constraint(equalTo: infoViewContainer.bottomAnchor, constant: logoSpacingBottom),
            
            // textAreaLavel Constraints
            textArea.leadingAnchor.constraint(equalTo: infoViewContainer.leadingAnchor, constant: 31.0),
            textArea.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: textAreaSpacingBottom),
            textArea.trailingAnchor.constraint(equalTo: infoViewContainer.trailingAnchor, constant: -31.0),
            
            // infoViewLabel Constraints
            infoViewLabel.bottomAnchor.constraint(equalTo: textArea.topAnchor, constant: infoLabelSpacingBottom),
            infoViewLabel.leadingAnchor.constraint(equalTo: infoViewContainer.leadingAnchor, constant: 31.0),
            infoViewLabel.heightAnchor.constraint(equalToConstant: 68.0),
            infoViewLabel.trailingAnchor.constraint(equalTo: infoViewContainer.trailingAnchor, constant: -62),
            
            // closeButton Constraints
            closeButton.centerYAnchor.constraint(equalTo: infoViewLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: infoViewContainer.trailingAnchor, constant: -31.0),
            closeButton.widthAnchor.constraint(equalToConstant: 29.0),
            closeButton.heightAnchor.constraint(equalToConstant: 29.0),
        ])
    }
    
}
