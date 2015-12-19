//
//  GoOutRecomDetailsTableViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/15/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class GoOutRecomDetailsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Public API
    var goOut: GoOut? {
        didSet {
            if let name = goOut?.name {
                recoms.append(Recom(title: Storyboard.NameSectionTitle, content: [Item.Text(name)]))
            }
            if let type = goOut?.type {
                recoms.append(Recom(title: Storyboard.TypeSectionTitle, content: [Item.Text(type)]))
            }
            if let time = goOut?.time {
                recoms.append(Recom(title: Storyboard.TimeSectionTitle, content: [Item.Text(time)]))
            }
            if let place = goOut?.place {
                recoms.append(Recom(title: Storyboard.PlaceSectionTitle, content: [Item.Text(place)]))
            }
            if let phone = goOut?.phone {
                recoms.append(Recom(title: Storyboard.PhoneSectionTitle, content: [Item.Text(phone)]))
            }
            recoms.append(Recom(title: Storyboard.ImageSectionTitle, content: [Item.Image(goOut?.imageData)]))
        }
    }
    
    // MARK: - Model for this tv
    
    var recoms = [Recom]() {
        didSet {
            tableView.reloadData()
        }
    }
    struct Recom {
        var title: String
        var content: [Item]
    }
    enum Item {
        case Text(String)
        case Image(NSData?)
    }
    
    // MARK: - Constants
    private struct Storyboard {
        static let TextCellIdentifier = "TextCell"
        static let ImageCellIdentifier = "ImageCell"
        
        static let NameSectionTitle = "Restaurant Name"
        static let TypeSectionTitle = "Food Type"
        static let TimeSectionTitle = "Opening Time"
        static let PlaceSectionTitle = "Address"
        static let PhoneSectionTitle = "Phone Number"
        static let ImageSectionTitle = "Mouth-watering Image"
        
        static let ImageShowSegue = "GoOutImageShow"
        static let ShowGoOutActionsSegue = "ShowGoOutActions"
    }
    
    
    @IBOutlet private weak var goOutActionsBarButtonItem: UIBarButtonItem!
    
    
    @IBAction private func showGoOutActions(sender: UIBarButtonItem) {
        performSegueWithIdentifier(Storyboard.ShowGoOutActionsSegue, sender: sender)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return recoms.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recoms[section].content.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return recoms[section].title
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = recoms[indexPath.section].content[indexPath.row]
        
        switch item {
        case .Text(let text):
            return GoOutRecomDetailsTextTableViewCell.heightForRecomText(text)
        case .Image(let imageData):
            if imageData != nil {
                let ar = UIImage(data: imageData!)!.aspectRatio
                return tableView.bounds.size.width / ar
                
            } else {
                return UITableViewAutomaticDimension
            }
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = recoms[indexPath.section].content[indexPath.row]
        
        switch item {
        case .Text(let text):
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath) as? GoOutRecomDetailsTextTableViewCell {
                cell.recomText = text
                return cell
            }
            
        case .Image(let imageData):
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath) as? GoOutRecomDetailsImageTableViewCell {
                cell.imageData = imageData
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return traitCollection.horizontalSizeClass == .Compact ? .OverFullScreen : .None
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        if style == .FullScreen || style == .OverFullScreen {
            let navcon = UINavigationController(rootViewController: controller.presentedViewController)
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
            visualEffectView.frame = navcon.view.bounds
            visualEffectView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
            navcon.view.insertSubview(visualEffectView, atIndex: 0)
            return navcon
        } else {
            return nil
        }
    }
    
    
    // MARK: - Unwind
    
    @IBAction func backFromGoOutActions(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                
        let destination = segue.destinationViewController.contentViewController
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ImageShowSegue:
                if let imagevc = destination as? ImageViewController,
                    let imageCell = sender as? GoOutRecomDetailsImageTableViewCell {
                        imagevc.imageData = imageCell.imageData
                        imagevc.title = title
                }
                
            case Storyboard.ShowGoOutActionsSegue:
                if let goOutavc = destination as? GoOutActionsViewController {
                    
                    if let ppc = goOutavc.popoverPresentationController {
                        ppc.barButtonItem = goOutActionsBarButtonItem
                        ppc.delegate = self
                    }
                    
                    goOutavc.goOut = goOut
                }
                
            default:
                break
            }
        }
        
    }
    
    
}


