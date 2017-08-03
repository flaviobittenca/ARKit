/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Methods on the main view controller for handling virtual object loading and movement
*/

import UIKit
import SceneKit

extension ViewController: VirtualCategorySelectionDelegate, VirtualObjectSelectionDelegate, VirtualObjectManagerDelegate {
    
    // MARK: - VirtualObjectManager delegate callbacks
    
    func virtualObjectManager(_ manager: VirtualObjectManager, willLoad object: VirtualObject) {
        DispatchQueue.main.async {
            // Show progress indicator
            self.spinner = UIActivityIndicatorView()
            self.spinner!.center = self.addObjectButton.center
            self.spinner!.bounds.size = CGSize(width: self.addObjectButton.bounds.width - 5, height: self.addObjectButton.bounds.height - 5)
            self.sceneView.addSubview(self.spinner!)
            self.spinner!.startAnimating()
            
            self.isLoadingObject = true
        }
    }
    
    func virtualObjectManager(_ manager: VirtualObjectManager, didLoad object: VirtualObject) {
        DispatchQueue.main.async {
            self.isLoadingObject = false
            
            // Remove progress indicator
            self.spinner?.removeFromSuperview()
        }
    }
    
    func virtualObjectManager(_ manager: VirtualObjectManager, couldNotPlace object: VirtualObject) {
        textManager.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
    }
    
    // MARK: - VirtualObjectSelectionDelegate

    func virtualObjectSelectionDelegate(_: ObjectsCollectionView, didSelectObjectAt index: Int) {
        guard let cameraTransform = session.currentFrame?.camera.transform else {
            return
        }
        
        let definition = VirtualObjectManager.availableObjects[index]
        let object = VirtualObject(definition: definition)
        let position = focusSquare?.lastPosition ?? float3(0)
        virtualObjectManager.loadVirtualObject(object, to: position, cameraTransform: cameraTransform)
        if object.parent == nil {
            serialQueue.async {
                self.sceneView.scene.rootNode.addChildNode(object)
            }
        }
        
        self.objectsHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func virtualObjectSelectionDelegate(_: ObjectsCollectionView, didDeselectObjectAt index: Int) {
        virtualObjectManager.removeVirtualObject(at: index)
    }
    
    // MARK: - VirtualCategorySelectionDelegate
    
    func virtualCategorySelectionDelegate(_: VirtualCategorySelectionViewController, didSelectCategoryAt index: Int) {
        objectsCollectionNibView?.objects = VirtualObjectManager.availableCategories[index].objects
        
        self.objectsHeightConstraint.constant = 140.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
