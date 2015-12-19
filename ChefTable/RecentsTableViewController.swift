//
//  RecentsTableViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/21/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController {
    
    // MARK: Private Implementation
    private struct Storyboard {
        static let RecentCellIdentifier = "RecentCell"
        static let RecentsDetailSegue = "RecentsDetailSegue"
    }
    
    // MARK: - UI
    
    @IBAction func clearHistory(sender: UIBarButtonItem) {
        Recents().choices.removeAll()
        tableView.reloadData()
    }

    
    // MARK: - VLC
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recently Saved Choices"
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recents().choices.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RecentCellIdentifier, forIndexPath: indexPath)
        
        let choice = Recents().choices[indexPath.row]
        
        cell.textLabel?.text = choice["name"]
        cell.detailTextLabel?.text = choice["date"]! + "\n" + choice["location"]!
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationvc: UIViewController? = segue.destinationViewController.contentViewController
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.RecentsDetailSegue:
                if let rdvc = destinationvc as? RecentsDetailViewController,
                    let recentCell = sender as? UITableViewCell {
                        
                        if let indexPath = tableView.indexPathForCell(recentCell) {
                            rdvc.choice = Recents().choices[indexPath.row]
                        }
 
                }
            
            default:
                break
            }
        }

    }
    
}
