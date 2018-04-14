//
//  ViewController.swift
//  ARGallery
//
//  Created by kingcos on 2018/4/14.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let nodeName = "verticalPlane"
    
    var currentAnchor: ARPlaneAnchor?
    
    // 平面
    var planes = Set<SCNNode>()
    // 绘画
    var paintings = [Painting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        // Debug Options
        sceneView.debugOptions = [
            ARSCNDebugOptions.showFeaturePoints,
//            ARSCNDebugOptions.showWorldOrigin
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.vertical]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    
    @IBAction func addImage(_ sender: Any) {
        let point = CGPoint(x: view.bounds.midX,
                            y: view.bounds.midY)
        let hitTestResults = sceneView.hitTest(point,
                                               types: .existingPlaneUsingExtent)
        if let result = hitTestResults.first {
            let column = result.worldTransform.columns.3
            let position = SCNVector3(column.x,
                                      column.y,
                                      column.z)
            let painting = Painting(position, currentAnchor)
            
            paintings.append(painting)
            sceneView.scene.rootNode.addChildNode(painting)
        }
        
        
//
//        let hitTestResults = sceneView.hitTest(point,
//                                               types: .featurePoint)
//        if let result = hitTestResults.first {
//            let column = result.worldTransform.columns.3
//            let position = SCNVector3(column.x,
//                                      column.y,
//                                      column.z)
//
//             let ARAnchorNode = SCNNode()
//             let planeNode = SCNNode()
//
//             // converting the ARAnchor to an ARPlaneAnchor to get access to ARPlaneAnchor's extent and center values
////             let anchor = anchor as? ARPlaneAnchor
//             // creating plane geometry
////             planeNode.geometry = SCNPlane(width: CGFloat((anchor?.extent.x)!), height: CGFloat((anchor?.extent.z)!))
//             // transforming node
//             planeNode.position = position // SCNVector3((anchor?.center.x)!, 0, (anchor?.center.z)!)
//             planeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "example.jpg")
//             planeNode.eulerAngles = SCNVector3(-Float.pi/2,0,0)
//             
//             // adding plane node as child to ARAnchorNode due to mandatory ARKit conventions
//             ARAnchorNode.addChildNode(planeNode)
//             //returning ARAnchorNode (must return a node from this function to add it to the scene)
//             nodes.append(planeNode)
            
//            let textNode = addTextNode("Test0Test0Test0Test0Test0Test0Test0Test0", at: position)
//            sceneView.scene.rootNode.addChildNode(textNode)
//        }
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController {
    func renderer(_ renderer: SCNSceneRenderer,
                  didAdd node: SCNNode,
                  for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        currentAnchor = planeAnchor
        let planeNode = createVerticalPlaneAt(anchor: planeAnchor)
        planes.insert(planeNode)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didUpdate node: SCNNode,
                  for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        currentAnchor = planeAnchor
        
        removeVerticalPlaneFrom(node)
        planes.remove(node)
        let planeNode = createVerticalPlaneAt(anchor: planeAnchor)
        planes.insert(planeNode)
        node.addChildNode(planeNode)
    }
    
//    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer,
//                  nodeFor anchor: ARAnchor) -> SCNNode? {
//        print(#function)
//        let node = SCNNode()
//
//
//
//        return node
//    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didRemove node: SCNNode,
                  for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        currentAnchor = nil
        removeVerticalPlaneFrom(node)
        planes.remove(node)
    }
    
    
    
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension ViewController {
    func createVerticalPlaneAt(anchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        
        planeNode.name = nodeName
        planeNode.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
                planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.position = SCNVector3Make(anchor.center.x, anchor.center.y, anchor.center.z)
        planeNode.eulerAngles = SCNVector3Make(Float(90.degreesToRad()), 0, 0)
        return planeNode
    }
    
    func removeVerticalPlaneFrom(_ node: SCNNode) {
        if let existingNode = node.childNode(withName: nodeName, recursively: false) {
            existingNode.removeFromParentNode()
        }
    }
}
