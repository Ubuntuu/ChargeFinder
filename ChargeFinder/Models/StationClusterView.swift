//
//  StationClusterView.swift
//  ChargeFinder
//
//  Created by Tommy Troest on 19/10/2018.
//  Copyright © 2018 TseorT. All rights reserved.
//

import Foundation
import MapKit

/********************************************************************************
 *  CLASS DESCRIPTION:
 *
 *  This class is used for customizing cluster, so that mapkit can display
 *  clusters different from MapKit standard red pin cluster annotations.
 */
internal final class StationClusterView: MKAnnotationView {
 
    // Overrides annotations with the custom cluster annotation.
    internal override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = false
            newValue.flatMap(configure(with:))
        }
    }
    
    // Initializer for cluster.
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
    
    // Error handling for clustering
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }
}

private extension StationClusterView {
    
    /***************************************************************************
     *  This function configures the clustered annotation view. It will draw a
     *  normal pin image, then display how many station annotations are
     *  clustered inside. If the station count is higher than 99 it will display
     *  99+.
     *  PARAMETERS: MKAnnotation
     */
    func configure(with annotation: MKAnnotation) {
        
        // Variables used for configuration
        guard let annotation = annotation as? MKClusterAnnotation else { return }
        let count = annotation.memberAnnotations.count
        let pinImage = UIImage(named: "pin")
        
        // Determines the count on the image.
        if count < 100 {
            image = textToImage(drawText: "\(count)" as NSString, inImage: pinImage!)
        } else {
            image = textToImage(drawText: "99+", inImage: pinImage!)
        }
    }
    
    /***************************************************************************
     *  This function will render text on the clustered pin, the text will
     *  depend on how many station are clustered in it.
     *  PARAMETERS:   NSString, UIImage
     *  RETURN:       UIImage
     */
    func textToImage(drawText text: NSString, inImage image: UIImage) -> UIImage {
        
        // Image Settings
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // Text and Font settings
        let font = UIFont(name: "Avenir-Black", size: 21)!
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let textColor = UIColor.darkGray
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle: textStyle, NSAttributedString.Key.foregroundColor: textColor]
        
        // Placement of Text in the image
        let textHeight = font.lineHeight
        let textY = ((image.size.height - textHeight) / 2) - 5
        let textRect = CGRect(x: 0, y: textY, width: image.size.width, height: textHeight)
        text.draw(in: textRect.integral, withAttributes: attributes)
        
        // Resulting Image
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}
