/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 SceneKit node wrapper for plane geometry detected in AR.
 */

import Foundation
import ARKit

class Plane: SCNNode {
    
    // MARK: - Properties
    
    var anchor: ARPlaneAnchor
    var focusSquare: FocusSquare?
    var groundPlane: SCNPlane?
    var groundVisible: Bool = false
    // MARK: - Initialization
    
    init(_ anchor: ARPlaneAnchor, ground: Bool) {
        self.anchor = anchor
        super.init()
        self.groundVisible = ground
        if groundVisible {
            initGroundPlane()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ARKit
    
    func update(_ anchor: ARPlaneAnchor) {
        self.anchor = anchor
        if groundVisible {
            updateGroundPlane()
        }
    }
    
    func initGroundPlane() {
        groundPlane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "oakfloor2-albedo.png")
        material.roughness.contents = #imageLiteral(resourceName: "oakfloor2-roughness.png")
        material.normal.contents = #imageLiteral(resourceName: "oakfloor2-normal.png")
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.roughness.wrapS = .repeat
        material.roughness.wrapT = .repeat
        material.metalness.wrapS = .repeat
        material.metalness.wrapT = .repeat
        material.normal.wrapS = .repeat
        material.normal.wrapT = .repeat
        
        groundPlane?.materials = [material]
        let planeNode = SCNNode(geometry: groundPlane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        // Planes in SceneKit are vertical by default so we need to rotate 90degrees to match
        // planes in ARKit
        planeNode.transform = SCNMatrix4MakeRotation(-.pi / 2.0, 1.0, 0.0, 0.0)
        //setTextureScale()
        addChildNode(planeNode)
    }
    
    func setGroundMaterial() {
        groundPlane?.materials.removeAll()
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "granitesmooth-albedo")
        material.roughness.contents = #imageLiteral(resourceName: "granitesmooth-roughness")
        material.normal.contents = #imageLiteral(resourceName: "granitesmooth-normal")
        material.metalness.contents = #imageLiteral(resourceName: "granitesmooth-metal")
        groundPlane?.materials = [material]
    }
    
    func updateGroundPlane() {
        // As the user moves around the extend and location of the plane
        // may be updated. We need to update our 3D geometry to match the
        // new parameters of the plane.
        groundPlane?.width = CGFloat(anchor.extent.x)
        groundPlane?.height = CGFloat(anchor.extent.z)
        // When the plane is first created it's center is 0,0,0 and the nodes
        // transform contains the translation parameters. As the plane is updated
        // the planes translation remains the same but it's center is updated so
        // we need to update the 3D geometry position
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        //setTextureScale()
    }
    
//    func setTextureScale() {
//        let material: SCNMaterial? = planeGeometry?.materials.first
//        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(planeGeometry!.width), Float(planeGeometry!.height), 1)
//        material?.diffuse.wrapS = .repeat
//        material?.diffuse.wrapT = .repeat
//    }
}


extension Plane {
    
    static func isNodePartOfPlane(_ node: SCNNode) -> Plane? {
        if let planeRoot = node as? Plane {
            return planeRoot
        }
        
        if node.parent != nil {
            return isNodePartOfPlane(node.parent!)
        }
        
        return nil
    }
    
}
