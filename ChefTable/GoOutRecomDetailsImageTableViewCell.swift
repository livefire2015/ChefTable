//
//  GoOutRecomDetailsImageTableViewCell.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/16/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class GoOutRecomDetailsImageTableViewCell: UITableViewCell {

    var imageData : NSData? {
        didSet { updateUI() }
    }
    
    
    @IBOutlet private weak var goOutRecomDetailsImageView: UIImageView!
    
    
    private func updateUI() {
        goOutRecomDetailsImageView?.image = nil
        
        if let imageData = self.imageData {
            goOutRecomDetailsImageView?.image = UIImage(data: imageData)
        }
    }
}
