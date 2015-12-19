//
//  IntrinsicallySizedImageView.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/19/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class IntrinsicallySizedImageView: UIImageView {
    
    
    // this UIImageView has an "unspecified" intrinsic size
    // that way, autolayout constraints can work on it
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
