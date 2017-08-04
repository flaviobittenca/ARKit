/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 SceneKit node wrapper for plane geometry detected in AR.
 */

import Foundation
import ARKit
import UIKit

class Plane: SCNNode {
    
    // MARK: - Properties
    
    var anchor: ARPlaneAnchor
    var focusSquare: FocusSquare?
    var groundPlane: SCNPlane?
    var currentMaterial: SCNMaterial?
    var tronGround: Bool = true
    // MARK: - Initialization
    
    init(_ anchor: ARPlaneAnchor, with groundMaterial: Bool) {
        self.anchor = anchor
        super.init()
        initGroundPlane(with: groundMaterial)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ARKit
    
    func update(_ anchor: ARPlaneAnchor) {
        self.anchor = anchor
        updateGroundPlane()
    }
    
    func initGroundPlane(with groundMaterial: Bool) {
        groundPlane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        if groundMaterial {
            setDefaultGroundMaterial()
        } else {
            setTransparentGroundMaterial()
        }
        let planeNode = SCNNode(geometry: groundPlane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        // Planes in SceneKit are vertical by default so we need to rotate 90degrees to match
        // planes in ARKit
        planeNode.transform = SCNMatrix4MakeRotation(-.pi / 2.0, 1.0, 0.0, 0.0)
        //setTextureScale()
        addChildNode(planeNode)
    }
    private func getTronMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "tronPlane")
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.roughness.wrapS = .repeat
        material.roughness.wrapT = .repeat
        material.metalness.wrapS = .repeat
        material.metalness.wrapT = .repeat
        material.normal.wrapS = .repeat
        material.normal.wrapT = .repeat
        return material
    }
    private func setDefaultGroundMaterial() {
        currentMaterial = getTronMaterial()
        groundPlane?.materials = [currentMaterial!]
        tronGround = true
    }
    
    func setCurrentMaterial() {
        if let material = currentMaterial {
            groundPlane?.materials = [material]
        }
    }
    
    func setTransparentGroundMaterial() {

        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "transparentPlane")
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.roughness.wrapS = .repeat
        material.roughness.wrapT = .repeat
        material.metalness.wrapS = .repeat
        material.metalness.wrapT = .repeat
        material.normal.wrapS = .repeat
        material.normal.wrapT = .repeat
        groundPlane?.materials = [material]
        currentMaterial = getTronMaterial()
        tronGround = true
    }
    
    func setFloorMaterial(with name: String? = nil) {
        if let assetName = name {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "\(assetName)-albedo")
            material.roughness.contents = UIImage(named: "\(assetName)-roughness")
            material.normal.contents = UIImage(named: "\(assetName)-normal")
            material.metalness.contents = UIImage(named: "\(assetName)-metalness")
            material.diffuse.wrapS = .repeat
            material.diffuse.wrapT = .repeat
            material.roughness.wrapS = .repeat
            material.roughness.wrapT = .repeat
            material.metalness.wrapS = .repeat
            material.metalness.wrapT = .repeat
            material.normal.wrapS = .repeat
            material.normal.wrapT = .repeat
            currentMaterial = material
            groundPlane?.materials = [currentMaterial!]
            tronGround = false
        }
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
