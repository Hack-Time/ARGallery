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
import Kingfisher

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let nodeName = "verticalPlane"
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    var currentAnchor: ARPlaneAnchor?
    
    var image: UIImage?
    
    // 平面
    var planes = Set<SCNNode>()
    // 绘画
    var paintings = [Painting]()
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
    }()
    
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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
//        UIApplication.shared.isIdleTimerDisabled = true
        
        resetTracking()
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        configuration.planeDetection = [.vertical]
//
//        // Run the view's session
//        sceneView.session.run(configuration)
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
            let painting = Painting(image!, position, currentAnchor)
            paintings.append(painting)
            sceneView.scene.rootNode.addChildNode(painting)
        } else {
            let alert = UIAlertController(title: "Sorry", message: "Plane hasn't found.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(alert, animated: true)
        }
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
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didRemove node: SCNNode,
                  for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        currentAnchor = nil
        removeVerticalPlaneFrom(node)
        planes.remove(node)
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
//        planeNode.eulerAngles = SCNVector3Make(Float(90.degreesToRad()), 0, 0)
        return planeNode
    }
    
    func removeVerticalPlaneFrom(_ node: SCNNode) {
        if let existingNode = node.childNode(withName: nodeName, recursively: false) {
            existingNode.removeFromParentNode()
        }
    }
}

extension ViewController {
    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
    func resetTracking() {
        
//        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
//            fatalError("Missing expected asset catalog resources.")
//        }
        
        let configuration = ARWorldTrackingConfiguration()
//        configuration.detectionImages = referenceImages
//        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        configuration.planeDetection = [.vertical]
        sceneView.session.run(configuration)
        
        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
    }
    
    // MARK: - Interface Actions
    
    func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false
        
        statusViewController.cancelAllScheduledMessages()
        
        resetTracking()
        
        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
}
