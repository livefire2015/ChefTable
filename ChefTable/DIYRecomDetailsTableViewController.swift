//
//  DiyRecomDetailsTableViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/17/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//


import UIKit

class DiyRecomDetailsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Public
    
    var diy: DIY?
    
    var option: String? {
        didSet {
            
            if let name = diy?.name {
                recoms.append(Recom(title: Storyboard.NameSectionTitle, content: [Item.Text(name)]))
            }
            if let type = diy?.type {
                recoms.append(Recom(title: Storyboard.TypeSectionTitle, content: [Item.Text(type)]))
            }
            
            switch option! {
            case Storyboard.ShowRecipeOption:
                if let recipe = diy?.recipe {
                    let recipeChecklist = recipe.componentsSeparatedByString("\n")
                    recoms.append(Recom(title: Storyboard.RecipeSectionTitle, content: recipeChecklist.map{Item.Text($0)}))
                }
            case Storyboard.ShowProcedureOption:
                if let procedure = diy?.procedure {
                    let procedureChecklist = procedure.componentsSeparatedByString("\n")
                    recoms.append(Recom(title: Storyboard.ProcedureSectionTitle, content: procedureChecklist.map{Item.Text($0)}))
                }
            case Storyboard.ShowImageOption:
                recoms.append(Recom(title: Storyboard.ImageSectionTitle, content: [Item.Image(diy?.imageData)]))
            default:
                break
            }
            
            
        }
    }
    
    
    // MARK: - Model for this tvc
    
    var recoms = [Recom]() {
        didSet { tableView.reloadData() }
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
        
        static let ShowRecipeOption = "Ingredients"
        static let ShowProcedureOption = "Instructions"
        static let ShowImageOption = "Image"
        
        static let TextCellIdentifier = "TextCell"
        static let CheckmarkImage = "checkmark"
        static let ImageCellIdentifier = "ImageCell"
        
        static let NameSectionTitle = "Your Dish Name"
        static let TypeSectionTitle = "Your Food Type"
        static let RecipeSectionTitle = "Your Ingredients"
        static let ProcedureSectionTitle = "Your Instructions"
        static let ImageSectionTitle = "Your Masterpiece Image"
        
        static let ImageShowSegue = "DiyImageShow"
        static let ShowDiyActionsSegue = "ShowDIYActions"
    }
    
    // MARK: - UI
    
    @IBOutlet private weak var diyActionsBarButtonItem: UIBarButtonItem!
    
    @IBAction private func showDIYActions(sender: UIBarButtonItem) {
        performSegueWithIdentifier(Storyboard.ShowDiyActionsSegue, sender: sender)
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
            return DiyRecomDetailsTextTableViewCell.heightForRecomText(text)
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
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath) as? DiyRecomDetailsTextTableViewCell {
                cell.recomText = text
                return cell
            }
            
        case .Image(let imageData):
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath) as? DiyRecomDetailsImageTableViewCell {
                cell.imageData = imageData
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let item = recoms[indexPath.section].content[indexPath.row]
        
        switch item {
        case .Text:
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? DiyRecomDetailsTextTableViewCell {
                
                if cell.imageView?.image == nil {
                    cell.imageView?.image = UIImage(named: Storyboard.CheckmarkImage)
                } else {
                    cell.imageView?.image = nil
                }
                
            }
            
        default:
            break
        }
        
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
    
    @IBAction func backFromDiyActions(segue: UIStoryboardSegue) {
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destination = segue.destinationViewController.contentViewController
        
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ImageShowSegue:
                if let imagevc = destination as? ImageViewController,
                    let imageCell = sender as? DiyRecomDetailsImageTableViewCell {
                        imagevc.imageData = imageCell.imageData
                        imagevc.title = title
                }
                
            case Storyboard.ShowDiyActionsSegue:
                if let diyavc = destination as? DiyActionsViewController {
                    
                    if let ppc = diyavc.popoverPresentationController {
                        ppc.barButtonItem = diyActionsBarButtonItem
                        ppc.delegate = self
                    }
                    
                    diyavc.diy = diy
                }
                
            default:
                break
            }
        }
        
    }
    
    
}
