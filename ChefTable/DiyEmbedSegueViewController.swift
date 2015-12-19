//
//  DiyEmbedSegueViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/18/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

// Ref:
/* Use Embed Segue to segue to SplitVC: http://stackoverflow.com/questions/20285402/ios-how-to-segue-from-single-view-to-split-view-controller  */

import UIKit

class DiyEmbedSegueViewController: UIViewController {
    
    // MARK: - Public
    
    var diy: DIY?
    
    // MARK: - Constants
    
    private struct StoryBoard {
        static let ShowSplitViewSegue = "ShowDiySplitView"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController.contentViewController
        if segue.identifier == StoryBoard.ShowSplitViewSegue {
            if let diysvc = destination as? DiySplitViewController where diy != nil {
                diysvc.diy = diy
            }
        }
        
        
    }
    

}
