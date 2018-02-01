//
//  BlendShapeCollectionViewCell.swift
//  FaceDebugger
//
//  Created by Ariel Scarpinelli on 1/31/18.
//  Copyright © 2018 Ariel Scarpinelli. All rights reserved.
//

import UIKit

class BlendShapeCollectionViewCell: UICollectionViewCell {
    
    var barHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var barView: UIView! {
        didSet {
            barHeightConstraint?.isActive = false
            barHeightConstraint = barView.heightAnchor.constraint(equalToConstant: 0)
            barHeightConstraint?.isActive = true
        }
    }
    
    public var blendShapeValue: Float = 0.0 {
        didSet {
            barHeightConstraint?.constant = CGFloat(blendShapeValue) * (self.frame.height - label.frame.height);
        }
    }
    
    public var name: String! = nil {
        didSet {
            label.text = name
        }
    }
    
    @IBOutlet weak var label: UILabel! {
        didSet {
            let frameBeforeRotation = label.frame;
            label.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2));
            label.frame = frameBeforeRotation;
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: self.bounds.height - label.frame.height, width:self.bounds.width, height:label.frame.height)
    }
}
