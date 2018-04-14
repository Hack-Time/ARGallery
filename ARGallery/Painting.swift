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

class Painting: SCNNode {
    init(_ position: SCNVector3, _ anchor: ARPlaneAnchor?) {
        super.init()
        
        self.position = position
        
        guard let anchor = anchor else { return }
        
//        self.geometry = SCNPlane(width: CGFloat(anchor.extent.x),
//                                 height: CGFloat(anchor.extent.z))
        self.geometry = SCNPlane(width: 0.5,
                                 height: 0.5)
        geometry?.firstMaterial?.diffuse.contents = UIImage(named: "example-result.jpg")
        eulerAngles = SCNVector3(0,0,0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
