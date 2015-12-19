//
//  DeletesTableViewController.swift
//  ChefTable
//
//  Created by Yangye Zhu on 12/1/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class DeletesTableViewController: UITableViewController {
    
    // MARK: Private Implementation
    private struct Storyboard {
        static let GoOutCategory = "Go out!"
        static let DIYCategory = "DIY!"
        
        static let DeleteCellIdentifier = "DeleteCell"
        
        static let FileTextContentSeparator = "###"
    }
    
    
    
    
    // MARK: - VLC
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trash"
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Deletes().deletes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.DeleteCellIdentifier, forIndexPath: indexPath)
        
        let delete = Deletes().deletes[indexPath.row]
        
        if let textFilename = delete["textFilename"] {
            let len = textFilename.characters.count
            let index = textFilename.startIndex.advancedBy(len - 4)
            cell.textLabel?.text = textFilename.substringToIndex(index)
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let delete = Deletes().deletes[indexPath.row]
        
        
        let ac = UIAlertController(title: cell?.textLabel?.text, message: "What do you want to do with this item?", preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Delete Forever", style: .Destructive) {
            (action: UIAlertAction) -> Void in
            
            if let cachesDirectory = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first {
                if let textFilename = delete["textFilename"] {
                    let textFileURL = cachesDirectory.URLByAppendingPathComponent(textFilename)
                    
                    if textFileURL.checkResourceIsReachableAndReturnError(nil) {
                        do {
                            try NSFileManager().removeItemAtURL(textFileURL)
                        } catch let error {
                            print("File Manager removeItemAtURL Error: \(error)")
                        }
                        
                    }
                    
                }
                
                if let imageFilename = delete["imageFilename"] {
                    let imageFileURL = cachesDirectory.URLByAppendingPathComponent(imageFilename)
                    if imageFileURL.checkResourceIsReachableAndReturnError(nil) {
                        do {
                            try NSFileManager().removeItemAtURL(imageFileURL)
                        } catch let error {
                            print("File Manager removeItemAtURL Error: \(error)")
                        }
                    }
                    
                }
                
                Deletes().deletes.removeAtIndex(indexPath.row)
                tableView.reloadData()
                
            }
            
            
            })
        ac.addAction(UIAlertAction(title: "Recover", style: .Default) {
            (action: UIAlertAction) -> Void in
            if let category = delete["category"], let context = AppDelegate.managedObjectContext,
                let cachesDirectory = NSFileManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first {
                    
                    switch category {
                    case Storyboard.GoOutCategory:
                        
                        var name: String?, type: String?, time: String?, place: String?, phone: String?, imageData: NSData?
                        if let textFilename = delete["textFilename"] {
                            let textFileURL = cachesDirectory.URLByAppendingPathComponent(textFilename)
                            if textFileURL.checkResourceIsReachableAndReturnError(nil) {
                                if let path = textFileURL.path,
                                    let textData = NSFileManager().contentsAtPath(path),
                                    let textContent = NSString(data: textData, encoding: NSUTF8StringEncoding) {
                                        let textComponents = textContent.componentsSeparatedByString(Storyboard.FileTextContentSeparator)
                                        name = textComponents[0]
                                        type = textComponents[1]
                                        time = textComponents[2]
                                        place = textComponents[3]
                                        phone = textComponents[4]
                                }
                            }
                        }
                        
                        if let imageFilename = delete["imageFilename"] {
                            let imageFileURL = cachesDirectory.URLByAppendingPathComponent(imageFilename)
                            if imageFileURL.checkResourceIsReachableAndReturnError(nil) {
                                if let path = imageFileURL.path {
                                    imageData = NSFileManager().contentsAtPath(path)
                                    
                                }
                            }
                        }
                        
                        context.performBlock{
                            if let name = name, let type = type, let time = time, let place = place, let phone = phone {
                                let goOutInfo = GoOut(withName: name, withType: type, withTime: time, withPlace: place, withPhone: phone, withImageData: imageData)
                                
                                GoOutRecomEntry.entryWithGoOutInfo(goOutInfo, inManagedObjectContext: context)
                            }
                            
                            do {
                                try context.save()
                            } catch let error {
                                print("Core Data Error: \(error)")
                            }
                            
                        }
                        
                        
                        
                    case Storyboard.DIYCategory:
                        
                        var name: String?, type: String?, recipe: String?, procedure: String?, imageData: NSData?
                        if let textFilename = delete["textFilename"] {
                            let textFileURL = cachesDirectory.URLByAppendingPathComponent(textFilename)
                            if textFileURL.checkResourceIsReachableAndReturnError(nil) {
                                if let path = textFileURL.path,
                                    let textData = NSFileManager().contentsAtPath(path),
                                    let textContent = NSString(data: textData, encoding: NSUTF8StringEncoding) {
                                        let textComponents = textContent.componentsSeparatedByString(Storyboard.FileTextContentSeparator)
                                        name = textComponents[0]
                                        type = textComponents[1]
                                        recipe = textComponents[2]
                                        procedure = textComponents[3]
                                }
                            }
                        }
                        
                        if let imageFilename = delete["imageFilename"] {
                            let imageFileURL = cachesDirectory.URLByAppendingPathComponent(imageFilename)
                            if imageFileURL.checkResourceIsReachableAndReturnError(nil) {
                                if let path = imageFileURL.path {
                                    imageData = NSFileManager().contentsAtPath(path)
                                    
                                }
                            }
                        }
                        
                        context.performBlock{
                            if let name = name, let type = type, let recipe = recipe, let procedure = procedure {
                                let diyInfo = DIY(withName: name, withType: type, withRecipe: recipe, withProcedure: procedure, withImageData: imageData)
                                
                                DIYRecomEntry.entryWithDIYInfo(diyInfo, inManagedObjectContext: context)
                            }
                            
                            do {
                                try context.save()
                            } catch let error {
                                print("Core Data Error: \(error)")
                            }
                            
                        }
                        
                        
                    default:
                        break
                    }

                    Deletes().deletes.removeAtIndex(indexPath.row)
                    tableView.reloadData()
                    
            }
            })
        
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    
    
}
