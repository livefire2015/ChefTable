//
//  DiySplitViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/18/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class DiySplitViewController: UISplitViewController {
    
    var diy: DIY? {
        didSet {
            if let diyvc = master as? DiyRecomOptionsForDetailsViewController {
                diyvc.diy = diy
            }
        }
    }
    
}

extension UISplitViewController {
    
    var master: UIViewController? {
        if let master = viewControllers.first {
            return master
        } else {
            return nil
        }
    }
    
    var detail: UIViewController? {
        if let detail = viewControllers.last where viewControllers.count == 2 {
            return detail
        } else {
            return nil
        }
    }
}
