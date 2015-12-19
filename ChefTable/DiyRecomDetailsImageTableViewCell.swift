//
//  DiyRecomDetailsImageTableViewCell.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/18/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class DiyRecomDetailsImageTableViewCell: UITableViewCell {

    var imageData : NSData? {
        didSet { updateUI() }
    }
    
    @IBOutlet private weak var diyRecomDetailsImageView: UIImageView!
    
    private func updateUI() {
        diyRecomDetailsImageView?.image = nil
        
        if let imageData = self.imageData {
            diyRecomDetailsImageView?.image = UIImage(data: imageData)
        }
    }

    
}
