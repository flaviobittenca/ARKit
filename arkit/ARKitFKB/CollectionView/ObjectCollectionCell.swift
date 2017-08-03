//
//  ObjectCollectionCell.swift
//  ARKitFKB
//
//  Created by Flavio Kruger Bittencourt on 03/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

class ObjectCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ObjectCollectionCell"
    
    @IBOutlet weak var objectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
