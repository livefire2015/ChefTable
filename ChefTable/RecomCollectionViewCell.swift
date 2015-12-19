//
//  RecomCollectionViewCell.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/12/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

// Ref: 
/* Programming iOS 8, Matt Neuburg, O'Reilly */

import UIKit
import QuartzCore

class RecomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public API
    var goOut: GoOut? { didSet { updateUI() } }
    
    var diy: DIY? { didSet { updateUI() } }
    
    
    // MARK: - UI
    @IBOutlet private weak var recomNameLabel: UILabel!
    
    @IBOutlet private weak var recomImageView: UIImageView! {
        didSet {
            recomImageView.layer.cornerRadius = CGRectGetHeight(recomImageView.frame) / 4.0;
        }
    }
    
    @IBOutlet private weak var recomDeleteButton: UIButton!

    
    // MARK: - Private
    
    private func updateUI() {
        
        recomNameLabel?.text = nil
        recomImageView?.image = nil
        
        if let goOut = self.goOut {
            recomNameLabel?.text = goOut.name
            if goOut.imageData != nil {
                recomImageView?.image = UIImage(data: goOut.imageData!)
            } else {
                recomImageView?.image = UIImage()
            }
        } else if let diy = self.diy {
            recomNameLabel?.text = diy.name
            if diy.imageData != nil {
                recomImageView?.image = UIImage(data: diy.imageData!)
            } else {
                recomImageView?.image = UIImage()
            }
        }
        
    }
    
    // MARK: - Custom Action for cell
    
    func dismiss(sender: AnyObject?) {
        
        var vv: UIView = self
        repeat {
            vv = vv.superview!
        } while !(vv is UICollectionView)
        
        if let cv = vv as? UICollectionView,
            let indexPath = cv.indexPathForCell(self) {
    
            let action = Selector(__FUNCTION__ + ":")
            cv.delegate?.collectionView?(cv, performAction: action, forItemAtIndexPath: indexPath, withSender: sender)
            
        }
        
    }
    
    func update(sender: AnyObject?) {
        
        var vv: UIView = self
        repeat {
            vv = vv.superview!
        } while !(vv is UICollectionView)
        
        if let cv = vv as? UICollectionView,
            let indexPath = cv.indexPathForCell(self) {
                
                let action = Selector(__FUNCTION__ + ":")
                cv.delegate?.collectionView?(cv, performAction: action, forItemAtIndexPath: indexPath, withSender: sender)
                
        }
    }

    
    
    
}
