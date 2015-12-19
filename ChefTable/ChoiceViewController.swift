//
//  ChoiceViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/17/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit
import CoreData

class ChoiceViewController: UIViewController {
    
    // MARK: - Public API
    
    var managedObjectContext: NSManagedObjectContext?
    
    var pageIndex: Int?
    
    var videoId: String?
    
    var intro: String?
    
    var choice: String?
    
    
    
    // MARK: - UI
    
    @IBOutlet private weak var playerView: YTPlayerView!
    
    @IBOutlet private weak var introLabel: UILabel!
    
    @IBOutlet private weak var choiceButton: UIButton!

    
    // MARK: - VCL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController.contentViewController
        if segue.identifier == Storyboard.ShowCollectionSegue {
            if let recomtvc = destination as? RecomTableViewController,
                let category = choice,
                let context = managedObjectContext {
                    
                    recomtvc.category = category
                    recomtvc.managedObjectContext = context
            }
        }
        
        
    }
    
    // MARK: - Private
    
    private func updateUI() {
        
        let playerVars: [String : Int] = ["playsinline" : 1]
        
        if let videoId = videoId, let intro = intro, let choice = choice {
            playerView.loadWithVideoId(videoId, playerVars: playerVars)
            introLabel.text = intro
            choiceButton.setTitle(choice, forState: .Normal)
        }
    }

    private struct Storyboard {
        static let ShowCollectionSegue = "ShowCollection"
    }

}


extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else if let tabbar = self as? UITabBarController {
            return tabbar.selectedViewController ?? tabbar
        } else {
            return self
        }
    }
}

