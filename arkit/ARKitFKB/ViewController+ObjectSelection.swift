/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Methods on the main view controller for handling virtual object loading and movement
 */

import UIKit
import SceneKit

extension ViewController: VirtualCategorySelectionDelegate, VirtualObjectSelectionDelegate, VirtualObjectManagerDelegate {
    
    // MARK: - VirtualObjectManager delegate callbacks
    
    func virtualObjectManager(_ manager: VirtualElementManager, willLoad object: VirtualElement) {
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
    
    func virtualObjectManager(_ manager: VirtualElementManager, didLoad object: VirtualElement) {
        DispatchQueue.main.async {
            self.isLoadingObject = false
            
            // Remove progress indicator
            self.spinner?.removeFromSuperview()
        }
    }
    
    func virtualObjectManager(_ manager: VirtualElementManager, couldNotPlace object: VirtualElement) {
        textManager.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
    }
    
    // MARK: - VirtualObjectSelectionDelegate
    
    func virtualObjectSelectionDelegate(_: ObjectsCollectionView, didSelectObjectAt index: Int) {
        guard let cameraTransform = session.currentFrame?.camera.transform else {
            return
        }
        
        let definition = VirtualElementManager.availableObjects(for: categorySelected!)[index]
        //if definition
        if definition.elementType == VirtualElementType.object.rawValue {
            let object = VirtualElement(definition: definition)
            let position = focusSquare?.lastPosition ?? float3(0)
            virtualObjectManager.loadVirtualObject(object, to: position, cameraTransform: cameraTransform)
            if object.parent == nil {
                serialQueue.async {
                    self.sceneView.scene.rootNode.addChildNode(object)
                }
            }
        } else {
            lastSelectedFloorName = definition.modelName
        }
        self.objectsHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func virtualObjectSelectionDelegate(_: ObjectsCollectionView, didDeselectObjectAt index: Int) {
        virtualObjectManager.removeVirtualObject(at: index, for: categorySelected!)
    }
    
    // MARK: - VirtualCategorySelectionDelegate
    
    func virtualCategorySelectionDelegate(_: VirtualCategorySelectionViewController, didSelectCategoryAt index: Int) {
        categorySelected = index
        objectsCollectionNibView?.objects = VirtualElementManager.availableCategories[index].objects
        
        self.objectsHeightConstraint.constant = 140.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController {
    
    func presentFloorPlanes() {
        let category = VirtualElementManager.availableCategories.filter {
            $0.category == "Floor"
            }.first
        objectsCollectionNibView?.objects = category!.objects
        
        self.objectsHeightConstraint.constant = 140.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}
