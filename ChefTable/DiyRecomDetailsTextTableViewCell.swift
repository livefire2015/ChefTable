//
//  DiyRecomDetailsTextTableViewCell.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/18/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class DiyRecomDetailsTextTableViewCell: UITableViewCell {

    var recomText : String? {
        didSet { updateUI() }
    }
    
    // A helper for table view row height
    class func heightForRecomText(recomTextString: String) -> CGFloat {
        let topMargin = CGFloat(35.0)
        let bottomMargin = CGFloat(39.0)
        let minHeight = CGFloat(85.0)
        
        let font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        
        let recomTextNSString = recomTextString as NSString
        let boundingBox: CGRect = recomTextNSString.boundingRectWithSize(CGSizeMake(570, CGFloat.max), options: [NSStringDrawingOptions.UsesFontLeading, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName : font], context: nil)
        
        return max(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin)
    }

    
    
    @IBOutlet private weak var diyRecomDetailsTextLabel: UILabel! {
        didSet { diyRecomDetailsTextLabel.numberOfLines = 0 }
    }

    private func updateUI() {
        diyRecomDetailsTextLabel?.text = nil
        
        if let recomText = self.recomText {
            diyRecomDetailsTextLabel?.text = recomText
        }
    }


}
