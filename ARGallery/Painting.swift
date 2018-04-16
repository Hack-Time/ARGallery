//
//  Painting.swift
//  ARGallery
//
//  Created by kingcos on 2018/4/15.
//  Copyright © 2018 kingcos. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import Kingfisher

class Painting: SCNNode {
    init(_ image: UIImage, _ position: SCNVector3, _ anchor: ARPlaneAnchor?) {
        super.init()
        
        self.position = position
        
        guard let anchor = anchor else {
            let alert = UIAlertController(title: "Sorry", message: "Plane hasn't found.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(alert)
            return
        }
        
//        self.geometry = SCNPlane(width: CGFloat(anchor.extent.x),
//                                 height: CGFloat(anchor.extent.z))
        self.geometry = SCNPlane(width: 0.5,
                                 height: 0.5)
        
        geometry?.firstMaterial?.diffuse.contents = image
        eulerAngles = SCNVector3(0, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Painting {
    func present(_ controller: UIViewController) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("Error - The rootViewController is nil.")
        }
        var currentController = rootViewController
        while let presentedController = currentController.presentedViewController {
            currentController = presentedController
        }
        
        currentController.present(controller, animated: true)
    }
}
