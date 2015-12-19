//
//  DiyRecomOptionsForDetailsViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/18/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class DiyRecomOptionsForDetailsViewController: UIViewController, UISplitViewControllerDelegate {
    
    // MARK: - Public API
    
    var diy: DIY?
    
    
    // MARK: - Constants
    
    private struct Storyboard {
        static let ShowDetailsSegue = "ShowDiyDetails"
    }
    
    // MARK: - Actions
    
    @IBAction private func showDiyDetails(sender: UIButton) {
        
        if let diytvc = splitViewController?.detail?.contentViewController as? DiyRecomDetailsTableViewController where diy != nil {
            diytvc.diy = diy
            diytvc.option = sender.currentTitle
        } else {
            performSegueWithIdentifier(Storyboard.ShowDetailsSegue, sender: sender)
        }

        
    }
    
    // MARK: - Unwind
    
    @IBAction func backFromDetail(segue: UIStoryboardSegue) {
        //print("back")
    }
    

    // MARK: - VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()

        splitViewController?.delegate = self
        
    }

    // MARK: UISplitViewControllerDelegate
    
    func splitViewController(
        splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController: UIViewController,
        ontoPrimaryViewController primaryViewController: UIViewController
        ) -> Bool {
            
            if let drdtvc = secondaryViewController.contentViewController as? DiyRecomDetailsTableViewController where drdtvc.diy == nil {
                return true
            } else {
                return false
            }
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController.contentViewController
        
        if segue.identifier == Storyboard.ShowDetailsSegue {
            if let diytvc = destination as? DiyRecomDetailsTableViewController where diy != nil {
                diytvc.diy = diy
                diytvc.option = (sender as? UIButton)?.currentTitle
            }
        }
        
        
    }
    

}
