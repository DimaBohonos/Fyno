//
//  CustomAnnotationView.swift
//  Fyno
//
//  Created by dima on 08.06.2024.
//

import UIKit
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var pinImage: UIImage!
    var visited: Bool!
}

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        update(for: annotation)
    }

    override var annotation: MKAnnotation? { didSet { update(for: annotation) } }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update(for annotation: MKAnnotation?) {
        
        let bounds = CGRect(x: 0, y: 0, width: 34, height: 40)
        let mainView = UIView(frame: bounds)
        let imageView = UIImageView(frame: bounds)
        imageView.image = UIImage(named: "pin_image")
        mainView.addSubview(imageView)
        let flagImageView = UIImageView(image: (annotation as? CustomAnnotation)?.pinImage)
        flagImageView.frame = CGRect(x: 3, y: 3, width: 28, height: 28)
        mainView.addSubview(flagImageView)
        
        if (annotation as? CustomAnnotation)?.visited == true {
            let checkImageView = UIImageView(image: UIImage(named: "icon_check"))
            checkImageView.frame = CGRect(x: 18, y: 0, width: 16, height: 16)
            mainView.addSubview(checkImageView)
            
        }
        
        image = mainView.getImage()
        
    }
}
